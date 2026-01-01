# 🚀 Quick Deploy to Railway (5 Minutes)

The fastest way to deploy your MLOps project to the cloud!

## ⚡ Super Quick Start

### Option 1: Web Interface (Easiest)

1. **Go to Railway**: https://railway.app
2. **Sign up** (free, no credit card needed)
3. **Click "New Project"** → **"Deploy from GitHub repo"**
4. **Select your repository**
5. **Railway auto-detects** your `railway.json` configuration
6. **Add environment variable**: `MLFLOW_TRACKING_URI` (if using separate MLflow service)
7. **Done!** Your API is live in ~2 minutes

### Option 2: CLI (For Power Users)

```bash
# 1. Install Railway CLI
npm i -g @railway/cli

# 2. Login
railway login

# 3. Deploy
railway init
railway up
```

That's it! 🎉

## 📝 What You Need

1. **GitHub Repository** with your code ✅
2. **Railway Account** (free signup)
3. **5 minutes** of your time

## 🔧 Environment Variables

Set these in Railway dashboard (Settings → Variables):

**For API Service:**
```
MLFLOW_TRACKING_URI=https://your-mlflow-url.railway.app
PORT=8000
```

**For MLflow Service (if separate):**
```
MLFLOW_BACKEND_STORE_URI=postgresql://user:pass@host/db
MLFLOW_DEFAULT_ARTIFACT_ROOT=file:./mlruns
PORT=5000
```

## 🎯 After Deployment

1. **Get your URL**: Railway provides a public URL
2. **Test it**: `curl https://your-app.railway.app/health`
3. **Share it**: Use in your presentation!

## 💡 Pro Tips

- **Free Tier**: $5 credit/month (perfect for demos)
- **Auto-Deploy**: Pushes to GitHub auto-deploy
- **Logs**: View in Railway dashboard
- **Metrics**: CPU/Memory usage included

## 🐛 Troubleshooting

**Service won't start?**
- Check logs: Railway dashboard → Logs
- Verify environment variables
- Check PORT is set correctly

**Can't connect to MLflow?**
- Verify MLflow service is running
- Check MLFLOW_TRACKING_URI is correct
- Ensure both services are in same project

## 📚 Full Guide

See [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md) for detailed instructions.

---

**Ready?** Go to https://railway.app and deploy now! 🚀


