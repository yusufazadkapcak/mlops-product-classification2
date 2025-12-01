#!/bin/bash
# Build and push Docker image to AWS ECR

set -e

# Load configuration
if [ -f aws/aws-config.env ]; then
    source aws/aws-config.env
else
    echo "❌ Configuration file not found. Run setup-aws.sh first"
    exit 1
fi

echo "=========================================="
echo "Building and Pushing Docker Image"
echo "=========================================="
echo ""

# Get ECR login
echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
echo "✅ ECR login successful"
echo ""

# Build Docker image
echo "Building Docker image..."
docker build -f docker/Dockerfile.inference -t product-classifier:latest .
echo "✅ Image built"
echo ""

# Tag image
echo "Tagging image..."
docker tag product-classifier:latest $ECR_REPO:latest
docker tag product-classifier:latest $ECR_REPO:$(date +%Y%m%d-%H%M%S)
echo "✅ Image tagged"
echo ""

# Push image
echo "Pushing image to ECR..."
docker push $ECR_REPO:latest
docker push $ECR_REPO:$(date +%Y%m%d-%H%M%S)
echo "✅ Image pushed"
echo ""

echo "=========================================="
echo "✅ Build and Push Complete!"
echo "=========================================="
echo ""
echo "Image URI: $ECR_REPO:latest"
echo ""

