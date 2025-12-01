"""FastAPI inference API for product classification."""
from fastapi import FastAPI, HTTPException  # type: ignore
from pydantic import BaseModel, Field  # type: ignore
from typing import Optional, List
import pandas as pd
import numpy as np
import joblib
from pathlib import Path
import sys

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from src.features.build_features import build_features
import lightgbm as lgb  # type: ignore

app = FastAPI(
    title="Product Classification API",
    description="API for predicting product categories",
    version="1.0.0"
)

# Global variables for model and label mapping
model = None
label_mapping = None


class ProductRequest(BaseModel):
    """Request model for product classification."""
    title: str = Field(..., description="Product title")
    seller_id: Optional[str] = Field(None, description="Seller ID")
    brand: Optional[str] = Field(None, description="Product brand")
    subcategory: Optional[str] = Field(None, description="Product subcategory")
    price: Optional[float] = Field(None, description="Product price")
    rating: Optional[float] = Field(None, description="Product rating")
    reviews_count: Optional[int] = Field(None, description="Number of reviews")


class PredictionResponse(BaseModel):
    """Response model for predictions."""
    category: str = Field(..., description="Predicted category")
    probabilities: dict = Field(..., description="Probability for each category")
    confidence: float = Field(..., description="Confidence score (max probability)")


def load_model(model_path: str = "models/model.txt", label_mapping_path: str = "models/label_mapping.joblib"):
    """Load the trained model and label mapping."""
    global model, label_mapping
    
    try:
        # Load LightGBM model
        if Path(model_path).exists():
            model = lgb.Booster(model_file=model_path)  # type: ignore
        else:
            # Try to load from MLflow
            import mlflow  # type: ignore
            client = mlflow.tracking.MlflowClient()
            try:
                model_version = client.get_latest_versions("product_classifier", stages=["Production"])[0]
                model_uri = f"models:/product_classifier/{model_version.version}"
                model = mlflow.lightgbm.load_model(model_uri)  # type: ignore
            except Exception:
                # Fallback: try to find any model
                print("Warning: Could not load model from MLflow. Using default path.")
                model = None
        
        # Load label mapping
        if Path(label_mapping_path).exists():
            label_mapping = joblib.load(label_mapping_path)
        else:
            print("Warning: Label mapping file not found. Using default mapping.")
            label_mapping = None
            
    except Exception as e:
        print(f"Error loading model: {e}")
        model = None
        label_mapping = None


@app.on_event("startup")
async def startup_event():
    """Load model on startup."""
    load_model()


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "Product Classification API",
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "predict": "/predict",
            "predict_batch": "/predict/batch"
        }
    }


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    return {"status": "healthy", "model_loaded": model is not None}


@app.post("/predict", response_model=PredictionResponse)
async def predict(request: ProductRequest):
    """
    Predict product category for a single product.
    
    Args:
        request: Product information
    
    Returns:
        Predicted category and probabilities
    """
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded. Please train a model first.")
    
    try:
        # Convert request to DataFrame
        data = pd.DataFrame([{
            "title": request.title,
            "seller_id": request.seller_id or "Unknown",
            "brand": request.brand or "Unknown",
            "subcategory": request.subcategory or "Unknown",
            "price": request.price or 0.0,
            "rating": request.rating or 0.0,
            "reviews_count": request.reviews_count or 0
        }])
        
        # Build features
        features = build_features(data)
        
        # Make prediction
        predictions = model.predict(features, num_iteration=model.best_iteration)
        predicted_class_idx = np.argmax(predictions[0])
        confidence = float(np.max(predictions[0]))
        
        # Map to label
        if label_mapping and "idx_to_label" in label_mapping:
            predicted_category = label_mapping["idx_to_label"][predicted_class_idx]
            # Create probabilities dict
            probabilities = {
                label_mapping["idx_to_label"][i]: float(prob)
                for i, prob in enumerate(predictions[0])
            }
        else:
            # Fallback: use index as category
            predicted_category = f"Category_{predicted_class_idx}"
            probabilities = {f"Category_{i}": float(prob) for i, prob in enumerate(predictions[0])}
        
        return PredictionResponse(
            category=predicted_category,
            probabilities=probabilities,
            confidence=confidence
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")


@app.post("/predict/batch")
async def predict_batch(requests: List[ProductRequest]):
    """
    Predict product categories for multiple products.
    
    Args:
        requests: List of product information
    
    Returns:
        List of predictions
    """
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded. Please train a model first.")
    
    try:
        # Convert requests to DataFrame
        data = pd.DataFrame([{
            "title": req.title,
            "seller_id": req.seller_id or "Unknown",
            "brand": req.brand or "Unknown",
            "subcategory": req.subcategory or "Unknown",
            "price": req.price or 0.0,
            "rating": req.rating or 0.0,
            "reviews_count": req.reviews_count or 0
        } for req in requests])
        
        # Build features
        features = build_features(data)
        
        # Make predictions
        predictions = model.predict(features, num_iteration=model.best_iteration)
        predicted_class_indices = np.argmax(predictions, axis=1)
        confidences = np.max(predictions, axis=1)
        
        # Map to labels
        results = []
        for idx, (pred_idx, conf) in enumerate(zip(predicted_class_indices, confidences)):
            if label_mapping and "idx_to_label" in label_mapping:
                predicted_category = label_mapping["idx_to_label"][pred_idx]
                probabilities = {
                    label_mapping["idx_to_label"][i]: float(prob)
                    for i, prob in enumerate(predictions[idx])
                }
            else:
                predicted_category = f"Category_{pred_idx}"
                probabilities = {f"Category_{i}": float(prob) for i, prob in enumerate(predictions[idx])}
            
            results.append({
                "category": predicted_category,
                "probabilities": probabilities,
                "confidence": float(conf)
            })
        
        return {"predictions": results}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Batch prediction error: {str(e)}")


if __name__ == "__main__":
    import uvicorn  # type: ignore
    import sys
    import os
    # Use 127.0.0.1 on Windows to avoid WinError 10022
    # For cloud deployment, use 0.0.0.0 and PORT from environment
    host = os.getenv("HOST", "127.0.0.1" if sys.platform == "win32" else "0.0.0.0")
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host=host, port=port)
