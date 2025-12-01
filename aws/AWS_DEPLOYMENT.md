# AWS Cloud Deployment Guide

Complete guide to deploy your MLOps Product Classification project to AWS.

## 🎯 Deployment Options

### Option 1: AWS ECS Fargate (Recommended)
- **Best for**: Production, scalable deployments
- **Cost**: Pay per use (~$10-30/month for demo)
- **Complexity**: Medium

### Option 2: AWS Elastic Beanstalk (Easiest)
- **Best for**: Quick deployment, less configuration
- **Cost**: Pay per use (~$10-20/month for demo)
- **Complexity**: Low

### Option 3: AWS EC2 (Most Control)
- **Best for**: Full control, custom configurations
- **Cost**: Pay per instance (~$15-30/month)
- **Complexity**: High

## 📋 Prerequisites

1. **AWS Account**: Sign up at https://aws.amazon.com
2. **AWS CLI**: Install from https://aws.amazon.com/cli/
3. **Docker**: Already installed ✅
4. **AWS Credentials**: Configure with `aws configure`

## 🚀 Quick Start: ECS Fargate Deployment

### Step 1: Configure AWS CLI

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### Step 2: Run Setup Script

```bash
cd mlops-product-classification
chmod +x aws/scripts/*.sh
./aws/scripts/setup-aws.sh
```

This will create:
- ✅ S3 bucket for MLflow artifacts
- ✅ ECR repository for Docker images
- ✅ ECS cluster
- ✅ CloudWatch log groups
- ✅ Configuration file (`aws/aws-config.env`)

### Step 3: Build and Push Docker Image

```bash
./aws/scripts/build-and-push.sh
```

This will:
- Build your Docker image
- Tag it for ECR
- Push to AWS ECR

### Step 4: Deploy Services

```bash
./aws/scripts/deploy-ecs.sh
```

This will:
- Register ECS task definitions
- Create/update ECS services
- Deploy MLflow and API services

### Step 5: Get Service URLs

```bash
# Get MLflow service IP
aws ecs list-tasks --cluster mlops-cluster --service-name mlflow-service --region us-east-1

# Get API service IP
aws ecs list-tasks --cluster mlops-cluster --service-name api-service --region us-east-1
```

## 🚀 Quick Start: Elastic Beanstalk (Easier)

### Step 1: Install EB CLI

```bash
pip install awsebcli
```

### Step 2: Initialize EB

```bash
cd mlops-product-classification
eb init -p docker -r us-east-1 product-classifier
```

### Step 3: Deploy

```bash
./aws/scripts/deploy-eb.sh
```

Or manually:
```bash
eb create product-classifier-env
```

### Step 4: Get URL

```bash
eb status
eb open
```

## 📊 Architecture

```
┌─────────────────┐
│   S3 Bucket     │
│  (Artifacts)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ECS Fargate     │
│  ┌───────────┐  │
│  │  MLflow    │  │
│  │  (Port 5K) │  │
│  └───────────┘  │
│  ┌───────────┐  │
│  │  FastAPI  │  │
│  │  (Port 8K) │  │
│  └───────────┘  │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│  CloudWatch     │
│  (Logs)         │
└─────────────────┘
```

## 🔧 Configuration

### Environment Variables

**For MLflow Service:**
```
MLFLOW_BACKEND_STORE_URI=file:./mlruns
MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://your-bucket/mlflow-artifacts
AWS_DEFAULT_REGION=us-east-1
```

**For API Service:**
```
MLFLOW_TRACKING_URI=http://mlflow-service-ip:5000
PORT=8000
HOST=0.0.0.0
AWS_DEFAULT_REGION=us-east-1
```

### Update Task Definitions

Before deploying, update these files:
- `aws/ecs-mlflow-task-definition.json`: Replace `YOUR_BUCKET_NAME`
- `aws/ecs-api-task-definition.json`: Replace `YOUR_ACCOUNT_ID`

Or use the setup script which does this automatically.

## 🧪 Testing

### Test MLflow Service

```bash
# Get MLflow service IP
MLFLOW_IP=$(aws ecs describe-tasks \
  --cluster mlops-cluster \
  --tasks $(aws ecs list-tasks --cluster mlops-cluster --service-name mlflow-service --query 'taskArns[0]' --output text) \
  --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
  --output text)

# Test MLflow UI
curl http://$MLFLOW_IP:5000
```

### Test API Service

```bash
# Get API service IP
API_IP=$(aws ecs describe-tasks \
  --cluster mlops-cluster \
  --tasks $(aws ecs list-tasks --cluster mlops-cluster --service-name api-service --query 'taskArns[0]' --output text) \
  --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' \
  --output text)

# Test health endpoint
curl http://$API_IP:8000/health

# Test prediction
curl -X POST "http://$API_IP:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Nike Pro Running Shoes",
    "brand": "Nike",
    "price": 129.99,
    "rating": 4.5
  }'
```

## 📊 Monitoring

### View Logs

```bash
# MLflow logs
aws logs tail /ecs/mlflow-server --follow --region us-east-1

# API logs
aws logs tail /ecs/product-classifier-api --follow --region us-east-1
```

### View Service Status

```bash
aws ecs describe-services \
  --cluster mlops-cluster \
  --services mlflow-service api-service \
  --region us-east-1
```

## 💰 Cost Management

### Free Tier (First 12 Months)
- **EC2**: 750 hours/month of t2.micro
- **S3**: 5GB storage
- **CloudWatch**: 10 custom metrics

### Estimated Monthly Cost (After Free Tier)
- **ECS Fargate**: ~$10-20 (0.5 vCPU, 1GB RAM, minimal usage)
- **S3**: ~$0.50 (for artifacts)
- **CloudWatch**: ~$1-2 (logs)
- **Total**: ~$12-25/month for demo

### Cost Optimization Tips
1. Stop services when not in use
2. Use smaller instance sizes
3. Set up auto-scaling to scale down
4. Use S3 lifecycle policies for old artifacts

## 🔒 Security

### IAM Roles

Create IAM roles for:
- **ECS Task Role**: Access to S3 and CloudWatch
- **ECR Access**: Push/pull images

### Security Groups

Ensure security groups allow:
- Port 5000 (MLflow) from your IP
- Port 8000 (API) from your IP

## 🐛 Troubleshooting

### Issue: Service won't start

**Check logs:**
```bash
aws logs tail /ecs/mlflow-server --region us-east-1
aws logs tail /ecs/product-classifier-api --region us-east-1
```

**Common fixes:**
- Verify environment variables
- Check task definition
- Verify ECR image exists
- Check security groups

### Issue: Can't connect to service

**Solution:**
1. Verify service is running: `aws ecs describe-services`
2. Check security groups allow your IP
3. Get public IP of task
4. Test connectivity

### Issue: S3 access denied

**Solution:**
1. Verify IAM role has S3 permissions
2. Check bucket policy
3. Verify bucket name is correct

## 📝 Next Steps

1. **Set up Application Load Balancer** (for public URLs)
2. **Configure Auto Scaling** (for production)
3. **Set up CloudWatch Alarms** (for monitoring)
4. **Configure Route 53** (for custom domain)

## 🔗 Useful Commands

```bash
# List all services
aws ecs list-services --cluster mlops-cluster

# Describe service
aws ecs describe-services --cluster mlops-cluster --services mlflow-service

# Update service
aws ecs update-service --cluster mlops-cluster --service mlflow-service --force-new-deployment

# Stop service
aws ecs update-service --cluster mlops-cluster --service mlflow-service --desired-count 0

# Delete service
aws ecs delete-service --cluster mlops-cluster --service mlflow-service --force
```

## ✅ Deployment Checklist

- [ ] AWS account created
- [ ] AWS CLI installed and configured
- [ ] Setup script run successfully
- [ ] Docker image built and pushed
- [ ] Services deployed
- [ ] MLflow service accessible
- [ ] API service accessible
- [ ] Health checks passing
- [ ] Logs visible in CloudWatch
- [ ] URLs documented for presentation

---

**Congratulations!** Your MLOps pipeline is now deployed to AWS! 🎉

