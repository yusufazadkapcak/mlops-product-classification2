#!/bin/bash
# Deploy services to AWS ECS

set -e

# Load configuration
if [ -f aws/aws-config.env ]; then
    source aws/aws-config.env
else
    echo "❌ Configuration file not found. Run setup-aws.sh first"
    exit 1
fi

echo "=========================================="
echo "Deploying to AWS ECS"
echo "=========================================="
echo ""

# Update task definitions with actual values
echo "Updating task definitions..."
sed -i.bak "s/YOUR_BUCKET_NAME/$S3_BUCKET/g" aws/ecs-mlflow-task-definition.json
sed -i.bak "s/YOUR_ACCOUNT_ID/$AWS_ACCOUNT_ID/g" aws/ecs-api-task-definition.json
sed -i.bak "s|YOUR_BUCKET_NAME|$S3_BUCKET|g" aws/ecs-mlflow-task-definition.json
echo "✅ Task definitions updated"
echo ""

# Register task definitions
echo "Registering MLflow task definition..."
MLFLOW_TASK_DEF=$(aws ecs register-task-definition \
    --cli-input-json file://aws/ecs-mlflow-task-definition.json \
    --region $AWS_REGION \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)
echo "✅ MLflow task definition registered: $MLFLOW_TASK_DEF"
echo ""

echo "Registering API task definition..."
API_TASK_DEF=$(aws ecs register-task-definition \
    --cli-input-json file://aws/ecs-api-task-definition.json \
    --region $AWS_REGION \
    --query 'taskDefinition.taskDefinitionArn' \
    --output text)
echo "✅ API task definition registered: $API_TASK_DEF"
echo ""

# Get default VPC and subnets
echo "Getting VPC and subnet information..."
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query 'Vpcs[0].VpcId' --output text --region $AWS_REGION)
SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' --output text --region $AWS_REGION | tr '\t' ',')
SG_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query 'SecurityGroups[0].GroupId' --output text --region $AWS_REGION)

echo "VPC ID: $VPC_ID"
echo "Subnet IDs: $SUBNET_IDS"
echo "Security Group: $SG_ID"
echo ""

# Create or update MLflow service
echo "Creating/updating MLflow service..."
aws ecs create-service \
    --cluster $CLUSTER_NAME \
    --service-name mlflow-service \
    --task-definition mlflow-server \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS],securityGroups=[$SG_ID],assignPublicIp=ENABLED}" \
    --region $AWS_REGION \
    2>/dev/null || \
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service mlflow-service \
    --task-definition mlflow-server \
    --region $AWS_REGION \
    --force-new-deployment
echo "✅ MLflow service deployed"
echo ""

# Create or update API service
echo "Creating/updating API service..."
aws ecs create-service \
    --cluster $CLUSTER_NAME \
    --service-name api-service \
    --task-definition product-classifier-api \
    --desired-count 1 \
    --launch-type FARGATE \
    --network-configuration "awsvpcConfiguration={subnets=[$SUBNET_IDS],securityGroups=[$SG_ID],assignPublicIp=ENABLED}" \
    --region $AWS_REGION \
    2>/dev/null || \
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service api-service \
    --task-definition product-classifier-api \
    --region $AWS_REGION \
    --force-new-deployment
echo "✅ API service deployed"
echo ""

echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="
echo ""
echo "Services are starting. Check status with:"
echo "  aws ecs describe-services --cluster $CLUSTER_NAME --services mlflow-service api-service --region $AWS_REGION"
echo ""
echo "View logs:"
echo "  aws logs tail $MLFLOW_LOG_GROUP --follow --region $AWS_REGION"
echo "  aws logs tail $API_LOG_GROUP --follow --region $AWS_REGION"
echo ""

