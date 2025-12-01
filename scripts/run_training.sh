#!/bin/bash
# Script to run the training pipeline

echo "Starting Product Classification Training Pipeline..."

# Check if MLflow is running
if ! curl -s http://localhost:5000 > /dev/null 2>&1; then
    echo "Warning: MLflow server not detected on port 5000"
    echo "Starting MLflow server in background..."
    mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 0.0.0.0 --port 5000 &
    sleep 5
fi

# Generate sample data if it doesn't exist
if [ ! -f "data/raw/products.csv" ]; then
    echo "Generating sample data..."
    python scripts/generate_sample_data.py
fi

# Run training
echo "Running training pipeline..."
python src/main.py

echo "Training completed! Check MLflow UI at http://localhost:5000"
