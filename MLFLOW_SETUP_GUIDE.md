# MLflow Localhost Setup Guide - Step by Step

This guide will help you set up and verify MLflow on localhost step by step.

## 📋 Prerequisites Check

Before starting, make sure you have:
- ✅ Python virtual environment activated
- ✅ MLflow installed (`pip install mlflow`)
- ✅ Project dependencies installed

## 🚀 Method 1: File-Based Tracking (Recommended for Windows)

This is the simplest method and works best on Windows.

### Step 1: Activate Virtual Environment

```powershell
# Navigate to project directory
cd mlops-product-classification

# Activate virtual environment
.\venv\Scripts\Activate.ps1
```

### Step 2: Verify MLflow is Installed

```powershell
python -c "import mlflow; print(f'MLflow version: {mlflow.__version__}')"
```

Expected output: `MLflow version: X.X.X`

### Step 3: Create MLruns Directory (if it doesn't exist)

```powershell
# This directory stores all MLflow tracking data
New-Item -ItemType Directory -Force -Path "mlruns" | Out-Null
```

### Step 4: Start MLflow UI

```powershell
python -m mlflow ui --backend-store-uri file:./mlruns --default-artifact-root ./mlruns --host 127.0.0.1 --port 5000 --workers 1
```

**What this does:**
- `--backend-store-uri file:./mlruns` - Uses file-based storage (no database needed)
- `--default-artifact-root ./mlflow/artifacts` - Where model artifacts are stored
- `--host 127.0.0.1` - Listen on localhost (Windows-friendly)
- `--port 5000` - Port number
- `--workers 1` - Single worker (avoids Windows socket issues)

### Step 5: Open MLflow UI

Once you see:
```
[INFO] Starting gunicorn 20.1.0
[INFO] Listening at: http://127.0.0.1:5000
```

Open your browser and go to: **http://127.0.0.1:5000**

You should see the MLflow UI with an empty experiments list (if you haven't run training yet).

### Step 6: Run a Test Training to Generate Data

In a **NEW terminal window** (keep MLflow UI running in the first one):

```powershell
# Activate venv
cd mlops-product-classification
.\venv\Scripts\Activate.ps1

# Run training
python src/main.py
```

This will:
1. Generate sample data (if needed)
2. Train a model
3. Log everything to MLflow
4. Create experiment runs visible in the UI

### Step 7: Refresh MLflow UI

Go back to your browser and refresh **http://127.0.0.1:5000**

You should now see:
- ✅ An experiment named "product_classification"
- ✅ At least one run with metrics, parameters, and artifacts
- ✅ Click on a run to see detailed information

---

## 🔧 Method 2: SQLite Backend (Alternative)

If you prefer using a SQLite database backend:

### Step 1-3: Same as Method 1

### Step 4: Start MLflow Server

```powershell
# Create artifacts directory
New-Item -ItemType Directory -Force -Path "mlflow\artifacts" | Out-Null

# Start server
python -m mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 127.0.0.1 --port 5000
```

### Step 5-7: Same as Method 1

**Note:** When using server mode, you need to update the tracking URI in your code:
```python
mlflow.set_tracking_uri("http://127.0.0.1:5000")
```

---

## ✅ Verification Checklist

Use this checklist to verify everything works:

- [ ] MLflow UI opens at http://127.0.0.1:5000
- [ ] No errors in the terminal where MLflow is running
- [ ] Can see the MLflow interface (even if empty)
- [ ] After running training, experiments appear in UI
- [ ] Can click on a run and see:
  - [ ] Metrics (accuracy, F1, etc.)
  - [ ] Parameters (model config)
  - [ ] Artifacts (model files)
  - [ ] Model registry (if model was registered)

---

## 🧪 Quick Test Script

Run this to verify MLflow is working:

```powershell
python scripts/verify_mlflow.py
```

This will:
1. Check if MLflow is installed
2. Test connecting to tracking URI
3. Create a test run
4. Log test metrics and parameters
5. Verify the run appears in MLflow

---

## 🐛 Troubleshooting

### Issue: Port 5000 already in use

**Solution:** Use a different port:
```powershell
python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5001
```
Then access at: http://127.0.0.1:5001

### Issue: "Connection refused" or can't connect

**Solutions:**
1. Make sure MLflow UI is running (check the terminal)
2. Use `127.0.0.1` instead of `localhost` on Windows
3. Check Windows Firewall isn't blocking port 5000
4. Try `--host 0.0.0.0` if `127.0.0.1` doesn't work

### Issue: No experiments showing after training

**Solutions:**
1. Make sure training used the same tracking URI
2. Check that `mlruns/` directory has files
3. Verify the experiment name matches
4. Try refreshing the browser

### Issue: "Module 'mlflow' has no attribute..."

**Solution:** This means the wrong mlflow module is being imported. Make sure:
- You're using `src.tracking_utils.tracking` (not `src.mlflow`)
- Virtual environment is activated
- MLflow is installed: `pip install mlflow`

---

## 📝 Quick Reference Commands

### Start MLflow UI (File-based)
```powershell
python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5000 --workers 1
```

### Start MLflow Server (SQLite)
```powershell
python -m mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 127.0.0.1 --port 5000
```

### Run Training (generates MLflow data)
```powershell
python src/main.py
```

### Check MLflow Version
```powershell
python -c "import mlflow; print(mlflow.__version__)"
```

### View MLflow in Browser
Open: **http://127.0.0.1:5000**

---

## 🎯 Next Steps

Once MLflow is working:

1. **Run Training**: `python src/main.py` to generate experiment data
2. **Explore UI**: Click through runs to see metrics, parameters, artifacts
3. **Compare Runs**: Use MLflow UI to compare different model versions
4. **Register Models**: Promote good models to Production stage
5. **View Model Registry**: See all registered model versions

---

## 💡 Tips

- Keep MLflow UI running in a separate terminal while you train models
- The UI auto-refreshes, but you can manually refresh to see new runs
- Use the search/filter features in MLflow UI to find specific runs
- Download model artifacts directly from the UI
- Export metrics and parameters for analysis

