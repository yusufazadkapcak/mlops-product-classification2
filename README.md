# MLOps Product Classification Project

A complete MLOps pipeline for e-commerce product category prediction using machine learning. This project demonstrates best practices in MLOps including data preprocessing, feature engineering, model training, experiment tracking, orchestration, and deployment.

## 🎯 Project Overview

This project predicts product categories based on:
- **Product titles** (text features)
- **High-cardinality features**: seller_id, brand, subcategory (using hash encoding)
- **Numerical features**: price, rating, reviews_count
- **Feature crosses**: brand × price_range

## ✨ Key Features

- ✅ **High-Cardinality Feature Handling**: Hash encoding for seller_id, brand, subcategory
- ✅ **Feature Engineering**: Feature crosses, text features, numerical transformations
- ✅ **MLflow Tracking**: Experiment tracking, model registry, and metrics visualization
- ✅ **Prefect Orchestration**: Automated pipeline (data_prep → train → evaluate → register)
- ✅ **FastAPI Deployment**: RESTful API for real-time predictions
- ✅ **Docker Containerization**: Ready for deployment
- ✅ **CI/CD Pipeline**: GitHub Actions for automated testing and training
- ✅ **Sample Data Generation**: Built-in synthetic data generator for testing

## 🏗️ Project Structure

```
mlops-product-classification/
├── src/
│   ├── data/              # Data loading and preprocessing
│   │   ├── load.py        # Load data (with sample data generation)
│   │   └── preprocess.py  # Data cleaning and splitting
│   ├── features/          # Feature engineering
│   │   └── build_features.py  # Hash features, feature crosses, text features
│   ├── models/            # Model training and evaluation
│   │   └── train.py       # LightGBM training with MLflow
│   ├── inference/         # Model serving
│   │   └── api.py         # FastAPI inference API
│   ├── tracking_utils/    # MLflow tracking utilities
│   │   └── tracking.py    # MLflow tracking helpers
│   ├── workflows/         # Orchestration
│   │   └── prefect_pipeline.py  # Prefect pipeline
│   └── main.py            # Main entry point
├── tests/
│   ├── unit/              # Unit tests
│   └── integration/       # Integration tests
├── docker/
│   ├── Dockerfile         # Training container
│   ├── Dockerfile.inference  # Inference container
│   └── docker-compose.yml # Full stack deployment
├── .github/workflows/     # CI/CD pipelines
│   ├── ci.yml             # Continuous integration
│   ├── train.yml          # Automated training
│   └── deploy.yml         # Deployment workflow
├── configs/               # Configuration files
│   └── default.yaml       # Default configuration
├── scripts/               # Utility scripts
│   └── generate_sample_data.py  # Sample data generator
└── requirements.txt       # Python dependencies
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Generate Sample Data

```bash
python scripts/generate_sample_data.py
```

This creates `data/raw/products.csv` with 10,000 synthetic product records.

### 3. Start MLflow Server

```bash
# Option 1: Docker Compose
cd mlflow
docker-compose up -d

# Option 2: Direct
mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 0.0.0.0 --port 5000
```

Access MLflow UI at `http://localhost:5000`

### 4. Run Training Pipeline

```bash
python src/main.py
```

This will:
1. Load and preprocess data
2. Build features (hash encoding, feature crosses)
3. Train LightGBM model
4. Evaluate on test set
5. Log to MLflow
6. Register model (optional)

### 5. Start Inference API

```bash
python -m uvicorn src.inference.api:app --host 0.0.0.0 --port 8000
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
```

## 📊 Model Details

### Algorithm
- **LightGBM**: Gradient boosting framework optimized for speed and performance
- **Objective**: Multi-class classification
- **Metrics**: Accuracy, Precision, Recall, F1-Score

### Feature Engineering

1. **Hash Encoding**: High-cardinality features (seller_id, brand, subcategory) → hash buckets
2. **Feature Crosses**: brand × price_range → hashed cross feature
3. **Text Features**: Title length, word count, keyword presence
4. **Numerical Features**: Price, rating, reviews_count (with log transformations)

### Hyperparameters

Default configuration (configurable in `configs/default.yaml`):
- `num_leaves`: 31
- `learning_rate`: 0.05
- `feature_fraction`: 0.9
- `bagging_fraction`: 0.8
- `num_boost_round`: 100

## 🔧 Configuration

Edit `configs/default.yaml` to customize:

```yaml
model:
  name: "product_classifier"
  
data:
  raw_data_path: "data/raw/"
  
training:
  test_size: 0.2
  random_seed: 42
  learning_rate: 0.05
  
mlflow:
  tracking_uri: "http://localhost:5000"
  experiment_name: "product_classification"
```

## 🐳 Docker Deployment

### Build and Run Training

```bash
docker build -f docker/Dockerfile -t product-classifier-train .
docker run -v $(pwd)/data:/app/data -v $(pwd)/models:/app/models product-classifier-train
```

### Build and Run Inference

```bash
docker build -f docker/Dockerfile.inference -t product-classifier-api .
docker run -p 8000:8000 -v $(pwd)/models:/app/models product-classifier-api
```

### Full Stack with Docker Compose

```bash
cd docker
docker-compose up -d
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows

1. **CI Pipeline** (`.github/workflows/ci.yml`):
   - Runs on push/PR to main/develop
   - Unit tests
   - Integration tests
   - Code linting

2. **Training Pipeline** (`.github/workflows/train.yml`):
   - Manual trigger or weekly schedule
   - Runs full training pipeline
   - Uploads model artifacts

3. **Deployment Pipeline** (`.github/workflows/deploy.yml`):
   - Triggers after successful training
   - Builds Docker image
   - Tests deployment

## 📈 MLflow Tracking

Track experiments, compare models, and manage model versions:

- **Experiments**: Organize runs by experiment name
- **Metrics**: Accuracy, precision, recall, F1-score
- **Parameters**: Model hyperparameters, feature configs
- **Artifacts**: Trained models, feature importance plots
- **Model Registry**: Version and stage models (Production/Staging/Archived)

Access MLflow UI: `http://localhost:5000`

## 🧪 Testing

```bash
# Run all tests
pytest

# Unit tests only
pytest tests/unit/

# Integration tests only
pytest tests/integration/

# With coverage
pytest --cov=src --cov-report=html
```

## 📝 API Documentation

Once the API is running, access interactive docs at:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

### Endpoints

- `GET /`: API information
- `GET /health`: Health check
- `POST /predict`: Single prediction
- `POST /predict/batch`: Batch predictions

## 🛠️ Technology Stack

- **ML Framework**: LightGBM, scikit-learn
- **MLOps**: MLflow, Prefect
- **API**: FastAPI, Uvicorn
- **Data Processing**: Pandas, NumPy
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Testing**: pytest

## 📚 Additional Resources

- [Quick Start Guide](QUICKSTART.md) - Detailed setup instructions
- [MLflow Documentation](https://www.mlflow.org/docs/latest/index.html)
- [Prefect Documentation](https://docs.prefect.io/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🎓 Learning Objectives

This project demonstrates:
- Handling high-cardinality categorical features
- Feature engineering best practices
- ML experiment tracking and versioning
- Pipeline orchestration
- Model deployment and serving
- CI/CD for ML projects
- Containerization for ML applications

## 🚨 Troubleshooting

### MLflow Connection Error
- Ensure MLflow server is running: `mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 0.0.0.0 --port 5000`
- Check `MLFLOW_TRACKING_URI` environment variable

### Model Not Found
- Train a model first: `python src/main.py`
- Check `models/` directory for saved models

### Port Conflicts
- Change ports in configuration files
- Use different ports for MLflow (5000) and API (8000)

## 📧 Support

For issues or questions, please open an issue on GitHub.
