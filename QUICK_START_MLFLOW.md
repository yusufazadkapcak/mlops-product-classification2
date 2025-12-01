# 🚀 Quick Start: MLflow on Localhost

## Fastest Way to Get MLflow Running

### Option 1: Use the Simple Script (Easiest)

```powershell
# Just run this one command:
.\scripts\start_mlflow_simple.ps1
```

Then open: **http://127.0.0.1:5000**

---

### Option 2: Manual Steps

**Step 1:** Activate virtual environment
```powershell
.\venv\Scripts\Activate.ps1
```

**Step 2:** Start MLflow UI
```powershell
python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5000 --workers 1
```

**Step 3:** Open browser
Go to: **http://127.0.0.1:5000**

---

## ✅ Verify It Works

Run the verification script:
```powershell
python scripts/verify_mlflow.py
```

This will:
- ✅ Check MLflow installation
- ✅ Test tracking URI
- ✅ Create a test experiment
- ✅ Show you what to do next

---

## 📊 Generate Data to View

After MLflow UI is running, in a **new terminal**:

```powershell
# Activate venv
.\venv\Scripts\Activate.ps1

# Run training (this creates experiment data)
python src/main.py
```

Then refresh your browser at **http://127.0.0.1:5000** to see the experiments!

---

## 🎯 What You Should See

1. **Empty UI** (if no training run yet) - This is normal!
2. **After running training:**
   - Experiment: "product_classification"
   - Runs with metrics (accuracy, F1, etc.)
   - Parameters (model config)
   - Artifacts (model files)

---

## 🐛 Troubleshooting

**Port 5000 in use?**
```powershell
# Use port 5001 instead
python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5001
```

**Can't connect?**
- Make sure MLflow is running (check terminal)
- Use `127.0.0.1` not `localhost` on Windows
- Check Windows Firewall

**No experiments showing?**
- Run training first: `python src/main.py`
- Refresh browser
- Check `mlruns/` directory exists

---

For detailed instructions, see: [MLFLOW_SETUP_GUIDE.md](MLFLOW_SETUP_GUIDE.md)

