#!/bin/bash
# Script to start MLflow server

echo "Starting MLflow server..."

# Create directories if they don't exist
mkdir -p mlflow/artifacts

# Start MLflow server
mlflow server \
    --backend-store-uri sqlite:///mlflow.db \
    --default-artifact-root ./mlflow/artifacts \
    --host 0.0.0.0 \
    --port 5000

echo "MLflow server started at http://localhost:5000"
