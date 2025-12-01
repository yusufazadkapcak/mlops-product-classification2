# 🚀 AWS Quick Start Guide

Deploy your MLOps project to AWS in 5 steps!

## ⚡ Prerequisites (5 minutes)

1. **Create AWS Account**: https://aws.amazon.com (free tier available)
2. **Install AWS CLI**: https://aws.amazon.com/cli/
3. **Configure AWS**: `aws configure`

## 🎯 Quick Deployment (10 minutes)

### Step 1: Setup AWS Resources

```bash
cd mlops-product-classification
chmod +x aws/scripts/*.sh
./aws/scripts/setup-aws.sh
```

This creates:
- S3 bucket for MLflow artifacts
- ECR repository for Docker images
- ECS cluster
- CloudWatch log groups

### Step 2: Build and Push Docker Image

```bash
./aws/scripts/build-and-push.sh
```

### Step 3: Deploy Services

```bash
./aws/scripts/deploy-ecs.sh
```

### Step 4: Get Service URLs

```bash
# View service status
aws ecs describe-services \
  --cluster mlops-cluster \
  --services mlflow-service api-service \
  --region us-east-1
```

### Step 5: Test Your Deployment

```bash
# Get API service IP (replace with actual IP from Step 4)
curl http://YOUR_API_IP:8000/health
```

## 💰 Cost

- **Free Tier**: 12 months free (t2.micro, 5GB S3)
- **After Free Tier**: ~$12-25/month for demo usage
- **Stop services** when not in use to save costs

## 🐛 Troubleshooting

**Service won't start?**
```bash
# Check logs
aws logs tail /ecs/mlflow-server --follow --region us-east-1
aws logs tail /ecs/product-classifier-api --follow --region us-east-1
```

**Can't connect?**
- Check security groups allow your IP
- Verify services are running
- Get public IP from ECS console

## 📚 Full Documentation

See [aws/AWS_DEPLOYMENT.md](aws/AWS_DEPLOYMENT.md) for complete guide.

---

**Ready?** Run the setup script and deploy! 🚀

