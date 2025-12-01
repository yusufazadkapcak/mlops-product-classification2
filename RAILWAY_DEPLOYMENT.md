# Railway Cloud Deployment Guide

This guide will help you deploy your MLOps Product Classification project to Railway - the easiest cloud platform for students.

## 🚀 Why Railway?

- ✅ **Free Tier**: $5 credit/month (perfect for demos)
- ✅ **Easy Setup**: Deploy in minutes
- ✅ **GitHub Integration**: Automatic deployments
- ✅ **PostgreSQL Included**: Built-in database for MLflow
- ✅ **No Credit Card Required**: For free tier

## 📋 Prerequisites

1. **Railway Account**: Sign up at https://railway.app
2. **GitHub Account**: Your code should be on GitHub
3. **Docker**: Already set up in your project ✅

## 🎯 Deployment Steps

### Step 1: Install Railway CLI (Optional but Recommended)

```bash
# Windows (PowerShell)
iwr https://railway.app/install.ps1 | iex

# Mac/Linux
curl -fsSL https://railway.app/install.sh | sh

# Or use npm
npm i -g @railway/cli
```

### Step 2: Login to Railway

```bash
railway login
```

This will open your browser to authenticate.

### Step 3: Create a New Project

```bash
# Navigate to your project directory
cd mlops-product-classification

# Initialize Railway project
railway init
```

Or use the web interface:
1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your repository

### Step 4: Add PostgreSQL Database (for MLflow)

**Option A: Via CLI**
```bash
railway add postgresql
```

**Option B: Via Web Interface**
1. In your Railway project, click "New"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically create the database

**Get Database URL:**
```bash
railway variables
# Look for DATABASE_URL or POSTGRES_URL
```

### Step 5: Deploy MLflow Server

**Option A: Deploy MLflow as Separate Service**

1. In Railway dashboard, click "New" → "GitHub Repo"
2. Select your repository
3. Add these environment variables:
   ```
   MLFLOW_BACKEND_STORE_URI=postgresql://user:pass@host:port/dbname
   MLFLOW_DEFAULT_ARTIFACT_ROOT=file:./mlruns
   PORT=5000
   ```
4. Set start command:
   ```
   pip install mlflow psycopg2-binary && mlflow server --host 0.0.0.0 --port $PORT
   ```

**Option B: Use Railway's PostgreSQL URL**

1. Get your PostgreSQL connection string:
   ```bash
   railway variables
   # Copy the DATABASE_URL
   ```

2. Create MLflow service with environment variables:
   ```
   MLFLOW_BACKEND_STORE_URI=$DATABASE_URL
   MLFLOW_DEFAULT_ARTIFACT_ROOT=file:./mlruns
   ```

### Step 6: Deploy FastAPI Application

**Via CLI:**
```bash
# Link to your Railway project
railway link

# Set environment variables
railway variables set MLFLOW_TRACKING_URI=https://your-mlflow-service.railway.app

# Deploy
railway up
```

**Via Web Interface:**
1. In Railway project, click "New" → "GitHub Repo"
2. Select your repository
3. Railway will detect the `railway.json` or `railway.toml` file
4. Add environment variables:
   ```
   MLFLOW_TRACKING_URI=https://your-mlflow-service.railway.app
   PORT=8000
   ```
5. Railway will automatically build and deploy

### Step 7: Configure Environment Variables

Set these in Railway dashboard (Settings → Variables):

**For MLflow Service:**
```
MLFLOW_BACKEND_STORE_URI=postgresql://user:pass@host:port/dbname
MLFLOW_DEFAULT_ARTIFACT_ROOT=file:./mlruns
PORT=5000
```

**For API Service:**
```
MLFLOW_TRACKING_URI=https://your-mlflow-service.railway.app
PORT=8000
PYTHONPATH=/app
```

### Step 8: Get Your URLs

After deployment, Railway will provide:
- **MLflow UI**: `https://your-mlflow-service.railway.app`
- **API Endpoint**: `https://your-api-service.railway.app`

## 🧪 Testing Your Deployment

### Test MLflow UI
```bash
# Open in browser
https://your-mlflow-service.railway.app
```

### Test API Health Check
```bash
curl https://your-api-service.railway.app/health
```

### Test API Prediction
```bash
curl -X POST "https://your-api-service.railway.app/predict" \
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

## 📊 Monitoring

Railway provides:
- **Logs**: View real-time logs in dashboard
- **Metrics**: CPU, Memory usage
- **Deployments**: History of all deployments

## 🔄 Continuous Deployment

Railway automatically deploys when you push to your GitHub repository!

1. Push code to GitHub
2. Railway detects changes
3. Automatically builds and deploys
4. Your service is updated

## 🐛 Troubleshooting

### Issue: Service won't start

**Check logs:**
```bash
railway logs
```

**Common fixes:**
- Verify environment variables are set
- Check PORT is set correctly
- Ensure MLFLOW_TRACKING_URI is accessible

### Issue: Can't connect to MLflow

**Solution:**
1. Verify MLflow service is running
2. Check MLFLOW_TRACKING_URI is correct
3. Ensure both services are in the same Railway project

### Issue: Database connection fails

**Solution:**
1. Verify PostgreSQL service is running
2. Check DATABASE_URL is correct
3. Ensure database is accessible from your service

## 💰 Cost Management

**Free Tier:**
- $5 credit/month
- 500 hours of usage
- Perfect for demos and testing

**To stay within free tier:**
- Stop services when not in use
- Use smaller instance sizes
- Monitor usage in Railway dashboard

## 🎯 Quick Deploy Script

Create `scripts/deploy_railway.sh`:

```bash
#!/bin/bash

echo "🚀 Deploying to Railway..."

# Login (if not already)
railway login

# Link project
railway link

# Set environment variables
railway variables set MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI

# Deploy
railway up

echo "✅ Deployment complete!"
echo "🌐 API URL: https://your-api-service.railway.app"
```

## 📝 Next Steps

1. **Train a model** using your deployed MLflow
2. **Register models** in MLflow Model Registry
3. **Test predictions** via your API
4. **Monitor** using Railway dashboard
5. **Share URLs** in your presentation!

## 🔗 Useful Links

- Railway Dashboard: https://railway.app/dashboard
- Railway Docs: https://docs.railway.app
- Railway Status: https://status.railway.app

## ✅ Deployment Checklist

- [ ] Railway account created
- [ ] Project initialized
- [ ] PostgreSQL database added
- [ ] MLflow service deployed
- [ ] API service deployed
- [ ] Environment variables configured
- [ ] MLflow UI accessible
- [ ] API health check passes
- [ ] Test prediction works
- [ ] URLs documented for presentation

---

**Congratulations!** Your MLOps pipeline is now deployed to the cloud! 🎉

