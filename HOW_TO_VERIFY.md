# How to Verify Your Project is Working Well

This guide helps you verify that all components of your MLOps pipeline are functioning correctly.

## 🧪 Quick Verification

### Run the Automated Verification Script

```powershell
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"
.\verify_project.ps1
```

This script checks:
- ✅ Python environment
- ✅ Virtual environment
- ✅ Required project files
- ✅ Model files
- ✅ Data files
- ✅ MLflow tracking
- ✅ API server status
- ✅ API predictions (single & batch)
- ✅ MLflow UI accessibility

---

## 📋 Manual Verification Checklist

### 1. **Environment Setup** ✓
```powershell
# Check Python version
python --version
# Should show: Python 3.x.x

# Check virtual environment
echo $env:VIRTUAL_ENV
# Should show path to venv
```

### 2. **Project Structure** ✓
Verify these files exist:
- `requirements.txt`
- `train_simple.py`
- `run_api_simple.py`
- `src/data/load.py`
- `src/models/train.py`
- `src/inference/api.py`

### 3. **Model Files** ✓
```powershell
# Check if model exists
Test-Path "models\model.txt"
Test-Path "models\label_mapping.joblib"
```

If missing, train a model:
```powershell
python train_simple.py
```

### 4. **Data Pipeline** ✓
```powershell
# Check if data exists (will auto-generate if missing)
Get-ChildItem "data\raw\*.csv"
```

### 5. **API Server** ✓

**Start the server:**
```powershell
.\start_api_only.ps1
```

**Test health endpoint:**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

**Expected response:**
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

### 6. **API Predictions** ✓

**Test single prediction:**
```powershell
$body = @{
    title = "iPhone 15 Pro Max"
    price = 999.99
    brand = "Apple"
    subcategory = "Electronics"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

**Expected response:**
```json
{
  "category": "Electronics",
  "confidence": 0.95,
  "probabilities": {
    "Electronics": 0.95,
    "Clothing": 0.03,
    ...
  }
}
```

**Or use the interactive docs:**
- Open: http://127.0.0.1:8000/docs
- Click `/predict` → "Try it out"
- Enter test data and click "Execute"

### 7. **Batch Predictions** ✓

```powershell
$batch = @(
    @{ title = "Nike Shoes"; price = 129.99; brand = "Nike" },
    @{ title = "Samsung TV"; price = 799.99; brand = "Samsung" }
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

### 8. **MLflow Tracking** ✓

**Start MLflow UI:**
```powershell
.\start_mlflow_only.ps1
```

**Access MLflow:**
- Open: http://127.0.0.1:5001 (or 5000 if available)
- You should see your training experiments
- Check metrics, parameters, and model artifacts

**Verify runs exist:**
```powershell
Get-ChildItem "mlruns" -Recurse -Directory | Select-Object FullName
```

---

## 🎯 End-to-End Test

### Complete Workflow Test

1. **Train a model:**
   ```powershell
   python train_simple.py
   ```
   - Should complete without errors
   - Should show training metrics
   - Should save model to `models/model.txt`

2. **Start API server:**
   ```powershell
   .\start_api_only.ps1
   ```

3. **Test predictions:**
   ```powershell
   .\test_api.ps1
   ```

4. **View results in MLflow:**
   - Open: http://127.0.0.1:5001
   - Check training metrics and model performance

---

## ✅ Success Indicators

Your project is working well if:

- ✅ All verification tests pass
- ✅ API server responds to health checks
- ✅ Predictions return valid categories with confidence scores
- ✅ MLflow UI shows training runs
- ✅ Model files exist and are accessible
- ✅ Data pipeline works (loads or generates data)
- ✅ No errors in console output

---

## 🐛 Common Issues & Solutions

### Issue: "Model not found"
**Solution:** Train a model first
```powershell
python train_simple.py
```

### Issue: "API server not responding"
**Solution:** Start the API server
```powershell
.\start_api_only.ps1
```

### Issue: "Port already in use"
**Solution:** Use alternative ports or stop the conflicting service
```powershell
# Find process using port
netstat -ano | findstr :8000

# Stop process (replace PID with actual process ID)
Stop-Process -Id <PID> -Force
```

### Issue: "No training runs in MLflow"
**Solution:** Run training again
```powershell
python train_simple.py
```

### Issue: "Virtual environment not activated"
**Solution:** Activate virtual environment
```powershell
.\venv\Scripts\Activate.ps1
```

---

## 📊 Performance Benchmarks

A well-working project should have:

- **Training Time:** < 5 minutes for 10,000 samples
- **Prediction Latency:** < 100ms per prediction
- **Model Accuracy:** > 70% (depends on data quality)
- **API Response Time:** < 200ms including feature engineering

---

## 🔄 Continuous Verification

Run verification regularly:

1. **After code changes:** Run `.\verify_project.ps1`
2. **After training:** Test predictions with `.\test_api.ps1`
3. **Before deployment:** Complete end-to-end test
4. **Weekly:** Check MLflow for model drift

---

## 📞 Need Help?

If verification fails:
1. Check the error messages in the verification output
2. Review the troubleshooting section above
3. Check logs in console output
4. Verify all services are running

---

**Remember:** A passing verification means your MLOps pipeline is production-ready! 🚀



