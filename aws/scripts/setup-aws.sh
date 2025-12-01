#!/bin/bash
# AWS Setup Script - Creates necessary AWS resources

set -e

echo "=========================================="
echo "AWS MLOps Setup Script"
echo "=========================================="
echo ""

# Configuration
REGION="us-east-1"
CLUSTER_NAME="mlops-cluster"
BUCKET_NAME="mlops-artifacts-$(date +%s)"
MLFLOW_LOG_GROUP="/ecs/mlflow-server"
API_LOG_GROUP="/ecs/product-classifier-api"

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Install it first:"
    echo "   https://aws.amazon.com/cli/"
    exit 1
fi

echo "✅ AWS CLI found"
echo ""

# Check AWS credentials
echo "Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured"
    echo "Run: aws configure"
    exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "✅ AWS Account ID: $ACCOUNT_ID"
echo "✅ Region: $REGION"
echo ""

# Create S3 bucket for MLflow artifacts
echo "Creating S3 bucket for MLflow artifacts..."
aws s3 mb s3://$BUCKET_NAME --region $REGION
echo "✅ Bucket created: $BUCKET_NAME"
echo ""

# Create CloudWatch log groups
echo "Creating CloudWatch log groups..."
aws logs create-log-group --log-group-name $MLFLOW_LOG_GROUP --region $REGION 2>/dev/null || echo "Log group exists"
aws logs create-log-group --log-group-name $API_LOG_GROUP --region $REGION 2>/dev/null || echo "Log group exists"
echo "✅ Log groups created"
echo ""

# Create ECR repository
echo "Creating ECR repository..."
aws ecr create-repository \
    --repository-name product-classifier \
    --region $REGION \
    2>/dev/null || echo "Repository already exists"
echo "✅ ECR repository created"
echo ""

# Get ECR login
echo "Getting ECR login..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
echo "✅ ECR login successful"
echo ""

# Create ECS cluster
echo "Creating ECS cluster..."
aws ecs create-cluster --cluster-name $CLUSTER_NAME --region $REGION 2>/dev/null || echo "Cluster already exists"
echo "✅ ECS cluster created"
echo ""

echo "=========================================="
echo "✅ AWS Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update task definitions with:"
echo "   - Bucket name: $BUCKET_NAME"
echo "   - Account ID: $ACCOUNT_ID"
echo "2. Build and push Docker image:"
echo "   ./aws/scripts/build-and-push.sh"
echo "3. Deploy services:"
echo "   ./aws/scripts/deploy-ecs.sh"
echo ""
echo "Configuration saved to: aws/aws-config.env"
echo ""

# Save configuration
cat > aws/aws-config.env <<EOF
AWS_ACCOUNT_ID=$ACCOUNT_ID
AWS_REGION=$REGION
S3_BUCKET=$BUCKET_NAME
CLUSTER_NAME=$CLUSTER_NAME
ECR_REPO=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/product-classifier
MLFLOW_LOG_GROUP=$MLFLOW_LOG_GROUP
API_LOG_GROUP=$API_LOG_GROUP
EOF

echo "Configuration saved to aws/aws-config.env"

