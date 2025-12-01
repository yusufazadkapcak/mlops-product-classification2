#!/bin/bash

# This script is used to deploy the machine learning model to a production environment.

# Set environment variables
export FLASK_APP=src/inference/api.py
export FLASK_ENV=production

# Build the Docker image for the inference service
docker build -t mlops-product-classification-inference -f docker/Dockerfile.inference .

# Run the Docker container for the inference service
docker run -d -p 5000:5000 mlops-product-classification-inference

echo "Deployment completed. The model is now running on http://localhost:5000"