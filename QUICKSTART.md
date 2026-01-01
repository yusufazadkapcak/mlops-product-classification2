# Quick Start Guide

This guide will help you get the MLOps Product Classification project up and running quickly.

## Prerequisites

- Python 3.10+
- Docker and Docker Compose (optional, for containerized deployment)
- Git

## Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Generate Sample Data

If you don't have a dataset, generate sample data:

```bash
python scripts/generate_sample_data.py
```

This will create `data/raw/products.csv` with 10,000 synthetic product records.

### 3. Start MLflow Server

In a separate terminal, start the MLflow tracking server:

```bash
# Option 1: Using Docker Compose
cd mlflow
docker-compose up -d

# Option 2: Direct Python
mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 0.0.0.0 --port 5000
```

MLflow UI will be available at `http://localhost:5000`

### 4. Run Training Pipeline

Train the model using Prefect:

```bash
python src/main.py
```

Or run the Prefect pipeline directly:

```bash
python src/workflows/prefect_pipeline.py
```

### 5. Start Inference API

In a separate terminal, start the FastAPI inference server:

```bash
python -m uvicorn src.inference.api:app --host 0.0.0.0 --port 8000
```

Or using Docker:

```bash
docker build -f docker/Dockerfile.inference -t product-classifier:latest .
docker run -p 8000:8000 product-classifier:latest
```

### 6. Test the API

```bash
# Health check
curl http://localhost:8000/health

# Single prediction
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Nike Pro Running Shoes Premium 2024",
    "seller_id": "SELLER_00001",
    "brand": "Nike",
    "subcategory": "Clothing",
    "price": 129.99,
    "rating": 4.5,
    "reviews_count": 1250
  }'

# Batch prediction
curl -X POST "http://localhost:8000/predict/batch" \
  -H "Content-Type: application/json" \
  -d '[
    {
      "title": "Samsung Galaxy Phone Pro",
      "brand": "Samsung",
      "price": 899.99
    },
    {
      "title": "Apple iPhone Premium",
      "brand": "Apple",
      "price": 1099.99
    }
  ]'
```

## Using Docker Compose

Run everything together:

```bash
cd docker
docker-compose up -d
```

This will start:
- MLflow server on port 5000
- Training pipeline (runs once)
- Inference API on port 8000

## Project Structure

```
mlops-product-classification/
├── src/
│   ├── data/           # Data loading and preprocessing
│   ├── features/       # Feature engineering
│   ├── models/         # Model training and evaluation
│   ├── inference/      # FastAPI inference API
│   ├── mlflow/         # MLflow tracking utilities
│   └── workflows/      # Prefect orchestration pipeline
├── tests/              # Unit and integration tests
├── docker/             # Docker configurations
├── .github/workflows/  # GitHub Actions CI/CD
└── configs/            # Configuration files
```

## Key Features

✅ **High-Cardinality Features**: Handles seller_id, brand, subcategory using hash encoding
✅ **Feature Engineering**: Feature crosses (brand × price_range), text features
✅ **MLflow Tracking**: Experiment tracking and model registry
✅ **Prefect Orchestration**: Automated pipeline with data_prep → train → evaluate → register
✅ **FastAPI Deployment**: RESTful API for model inference
✅ **Docker Containerization**: Ready for deployment
✅ **CI/CD**: GitHub Actions for automated testing and training

## Next Steps

1. **Add Real Data**: Replace sample data with your actual dataset
2. **Tune Hyperparameters**: Experiment with different model configurations
3. **Deploy to Cloud**: Deploy to AWS, GCP, or Azure
4. **Set Up Monitoring**: Add monitoring and alerting for model performance
5. **A/B Testing**: Implement A/B testing for model versions

## Troubleshooting

### MLflow Connection Error
- Ensure MLflow server is running on port 5000
- Check `MLFLOW_TRACKING_URI` environment variable

### Model Not Found Error
- Train a model first using `python src/main.py`
- Check that models are saved in `models/` directory

### Port Already in Use
- Change ports in docker-compose.yml or use different ports
- Kill existing processes: `lsof -ti:8000 | xargs kill` (Linux/Mac)

## Support

For issues or questions, please open an issue on GitHub.




