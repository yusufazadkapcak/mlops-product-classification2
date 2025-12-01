# AWS Deployment Checklist

## ✅ Completed Steps

- [x] **Install AWS CLI** ✅ DONE
- [x] **Add AWS CLI to PATH** ✅ DONE

## 🔄 Current Step

- [ ] **Configure AWS CLI** - Run `aws configure` (you need AWS credentials)

## 📋 Remaining Steps

### Step 1: Configure AWS CLI ⬅️ YOU ARE HERE

```powershell
aws configure
```

**You need:**
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1`
- Default output: `json`

**Get credentials from:**
- AWS Console → IAM → Users → Security Credentials → Create Access Key

---

### Step 2: Create AWS Resources

```powershell
cd mlops-product-classification
# Make scripts executable (if using Git Bash or WSL)
chmod +x aws/scripts/*.sh
# Run setup
bash aws/scripts/setup-aws.sh
```

**Or use PowerShell:**
```powershell
# The script will create:
# - S3 bucket for MLflow artifacts
# - ECR repository for Docker images  
# - ECS cluster
# - CloudWatch log groups
```

---

### Step 3: Build and Push Docker Image

```powershell
bash aws/scripts/build-and-push.sh
```

**This will:**
- Build your Docker image
- Tag it for AWS ECR
- Push to AWS ECR repository

---

### Step 4: Deploy Services to ECS

```powershell
bash aws/scripts/deploy-ecs.sh
```

**This will:**
- Register ECS task definitions
- Create MLflow service
- Create API service
- Deploy both services

---

### Step 5: Get Service URLs

```powershell
# Check service status
aws ecs describe-services `
  --cluster mlops-cluster `
  --services mlflow-service api-service `
  --region us-east-1
```

---

### Step 6: Test Your Deployment

```powershell
# Test API health (replace with actual IP)
curl http://YOUR_API_IP:8000/health

# Test prediction
curl -X POST "http://YOUR_API_IP:8000/predict" `
  -H "Content-Type: application/json" `
  -d '{\"title\": \"Nike Shoes\", \"brand\": \"Nike\", \"price\": 129.99}'
```

---

## 🎯 Quick Summary

**Total Steps: 6**
- ✅ Step 0: Install AWS CLI (DONE)
- ⬅️ **Step 1: Configure AWS CLI** (CURRENT)
- ⏭️ Step 2: Setup AWS Resources
- ⏭️ Step 3: Build & Push Docker Image
- ⏭️ Step 4: Deploy Services
- ⏭️ Step 5: Get URLs
- ⏭️ Step 6: Test Deployment

---

## 💡 Next Action

**Right now, you need to:**

1. **Get AWS credentials** (if you don't have them):
   - Go to: https://console.aws.amazon.com
   - IAM → Users → Your User → Security Credentials
   - Create Access Key

2. **Configure AWS CLI:**
   ```powershell
   aws configure
   ```

3. **Test configuration:**
   ```powershell
   aws sts get-caller-identity
   ```

4. **Then proceed to Step 2** (setup AWS resources)

---

## ⏱️ Estimated Time

- **Step 1** (Configure): 2-3 minutes
- **Step 2** (Setup): 3-5 minutes
- **Step 3** (Build): 5-10 minutes
- **Step 4** (Deploy): 3-5 minutes
- **Step 5-6** (Test): 2-3 minutes

**Total: ~15-25 minutes**

---

**You're at Step 1 of 6. Keep going!** 🚀

