# Expected Outputs - What Success Looks Like

This document shows you what the correct outputs should look like for each component of your MLOps pipeline.

---

## 1. ✅ Verification Script Output

When you run `.\verify_project.ps1`, you should see:

```
========================================
MLOps Project Verification
========================================

[1/10] Checking Python Environment...
[2/10] Checking Virtual Environment...
[3/10] Checking Project Files...
[4/10] Checking Model Files...
[5/10] Checking Data Files...
[6/10] Checking MLflow Tracking...
[7/10] Checking API Server...
[8/10] Testing API Prediction...
[9/10] Testing Batch Prediction...
[10/10] Checking MLflow UI...

========================================
VERIFICATION RESULTS
========================================

✓ PASS - Python Environment
  → Python is installed: Python 3.14.0

✓ PASS - Virtual Environment
  → Virtual environment is activated: C:\Users\melis\...\venv

✓ PASS - Project Files
  → All required files present

✓ PASS - Model File
  → Model exists (245.67 KB)

✓ PASS - Label Mapping
  → Label mapping file exists

✓ PASS - Data Files
  → Found 1 CSV file(s) with ~10000 rows

✓ PASS - MLflow Tracking
  → Found 3 training run(s)

✓ PASS - API Server
  → API server is running and healthy

✓ PASS - API Prediction
  → Prediction successful: Electronics (confidence: 87.45%)

✓ PASS - Batch Prediction
  → Batch prediction successful for 2 products

✓ PASS - MLflow UI
  → MLflow UI is accessible on port 5001

========================================
✓ ALL TESTS PASSED!
Your MLOps pipeline is working correctly!
========================================
```

---

## 2. ✅ API Health Check Output

**Request:**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

**Expected Response:**
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

**Or in browser (http://127.0.0.1:8000/health):**
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

---

## 3. ✅ Single Prediction Output

**Request:**
```powershell
$body = @{
    title = "iPhone 15 Pro Max 256GB"
    price = 999.99
    brand = "Apple"
    subcategory = "Electronics"
    rating = 4.8
    reviews_count = 5000
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

**Expected Response:**
```json
{
  "category": "Electronics",
  "confidence": 0.9245,
  "probabilities": {
    "Electronics": 0.9245,
    "Clothing": 0.0234,
    "Home & Kitchen": 0.0156,
    "Sports & Outdoors": 0.0123,
    "Books": 0.0089,
    "Toys & Games": 0.0056,
    "Beauty": 0.0034,
    "Automotive": 0.0023,
    "Garden": 0.0012,
    "Pet Supplies": 0.0008,
    "Baby": 0.0004,
    "Office": 0.0002
  }
}
```

**What to look for:**
- ✅ `category` field exists and is a string
- ✅ `confidence` is a number between 0 and 1
- ✅ `probabilities` contains all categories
- ✅ Highest probability matches the predicted category

---

## 4. ✅ Batch Prediction Output

**Request:**
```powershell
$batch = @(
    @{ title = "Nike Air Max Running Shoes"; price = 129.99; brand = "Nike"; subcategory = "Clothing" },
    @{ title = "Samsung 4K Smart TV 55 inch"; price = 799.99; brand = "Samsung"; subcategory = "Electronics" }
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

**Expected Response:**
```json
{
  "predictions": [
    {
      "category": "Clothing",
      "confidence": 0.8567,
      "probabilities": {
        "Clothing": 0.8567,
        "Sports & Outdoors": 0.0892,
        "Electronics": 0.0234,
        ...
      }
    },
    {
      "category": "Electronics",
      "confidence": 0.9123,
      "probabilities": {
        "Electronics": 0.9123,
        "Home & Kitchen": 0.0456,
        "Clothing": 0.0123,
        ...
      }
    }
  ],
  "total_processed": 2,
  "processing_time_ms": 45.2
}
```

**What to look for:**
- ✅ `predictions` array with same length as input
- ✅ Each prediction has `category`, `confidence`, and `probabilities`
- ✅ `total_processed` matches input count
- ✅ `processing_time_ms` is reasonable (< 500ms)

---

## 5. ✅ Training Pipeline Output

When you run `python train_simple.py`, you should see:

```
============================================================
Product Classification Training Pipeline
============================================================

[1/6] Setting up MLflow...
✓ MLflow configured (file-based tracking)

[2/6] Loading data...
  → Checking for existing dataset...
✓ Found existing dataset: data\raw\products.csv
✓ Loading dataset from: data\raw\products.csv
✓ Loaded 10000 rows, 8 columns
✓ Dataset ready: 10000 samples

[3/6] Preprocessing data...
✓ Preprocessed 10000 samples

[4/6] Building features...
✓ Built 25 features

[5/6] Splitting data...
✓ Train: 6400, Val: 1600, Test: 2000

[6/6] Training model...
------------------------------------------------------------
[LightGBM] [Info] Number of positive cases in train_data: 6400
[LightGBM] [Info] Number of classes: 12
[LightGBM] [Info] Number of data: 6400, number of features: 25
[LightGBM] [Info] Start training from score 0.000000
[10]	train's multi_logloss: 1.23456	val's multi_logloss: 1.34567
[20]	train's multi_logloss: 0.98765	val's multi_logloss: 1.12345
...
[100]	train's multi_logloss: 0.45678	val's multi_logloss: 0.56789
Model saved locally to: models\model.txt
Model trained successfully!
Training Accuracy: 0.8234
Training F1 Score: 0.8156
Validation Accuracy: 0.8012
Validation F1 Score: 0.7934
------------------------------------------------------------
✓ Model trained successfully!

[7/7] Evaluating on test set...

Classification Report:
              precision    recall  f1-score   support

   Electronics       0.85      0.88      0.86       450
      Clothing       0.82      0.79      0.80       380
Home & Kitchen       0.78      0.81      0.79       320
...
      accuracy                           0.80      2000
     macro avg       0.80      0.80      0.80      2000
  weighted avg       0.80      0.80      0.80      2000

============================================================
TRAINING COMPLETE - RESULTS
============================================================
Train Accuracy:  0.8234
Train F1 Score: 0.8156
Val Accuracy:   0.8012
Val F1 Score:   0.7934
Test Accuracy:  0.7987
Test F1 Score:  0.7901
============================================================

To view results in MLflow UI, run:
  python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5000 --workers 1
Then open: http://127.0.0.1:5000
============================================================
```

**What to look for:**
- ✅ No errors during execution
- ✅ Training metrics improve over iterations
- ✅ Accuracy > 0.70 (70%)
- ✅ Model file created: `models/model.txt`
- ✅ Label mapping created: `models/label_mapping.joblib`

---

## 6. ✅ API Server Startup Output

When you run `python run_api_simple.py` or `.\start_api_only.ps1`:

```
Project root: C:\Users\melis\...\mlops-product-classification
Starting FastAPI server...
Server will be at: http://127.0.0.1:8000
API docs: http://127.0.0.1:8000/docs

Press Ctrl+C to stop

INFO:     Started server process [12345]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
```

**What to look for:**
- ✅ "Application startup complete" message
- ✅ Server running on http://127.0.0.1:8000
- ✅ No error messages

---

## 7. ✅ MLflow UI Output

When you run `.\start_mlflow_only.ps1`:

```
Starting MLflow UI...

MLflow UI will be available at: http://127.0.0.1:5001
Press Ctrl+C to stop

[2025-12-01 02:45:12 +0000] [12345] [INFO] Starting gunicorn 21.2.0
[2025-12-01 02:45:12 +0000] [12345] [INFO] Listening at: http://127.0.0.1:5001 (12345)
[2025-12-01 02:45:12 +0000] [12345] [INFO] Using worker: sync
[2025-12-01 02:45:12 +0000] [12345] [INFO] Booting worker with pid: 12345
```

**In Browser (http://127.0.0.1:5001):**
- ✅ MLflow UI loads
- ✅ Shows "product_classification" experiment
- ✅ Lists training runs with metrics
- ✅ Can view model artifacts

---

## 8. ✅ Test API Script Output

When you run `.\test_api.ps1`:

```
Testing Product Classification API...

1. Testing Health Endpoint...
   ✓ Health Check: healthy
   Model Loaded: True

2. Testing Single Prediction...
   ✓ Prediction Successful!
   Predicted Category: Electronics
   Confidence: 92.45%
   Top Probabilities:
     - Electronics: 92.45%
     - Clothing: 2.34%
     - Home & Kitchen: 1.56%

3. Testing Batch Prediction...
   ✓ Batch Prediction Successful!
   Processed 2 products
     - Clothing (confidence: 85.67%)
     - Electronics (confidence: 91.23%)

========================================
API Testing Complete!
========================================

Access API Docs at: http://127.0.0.1:8000/docs
Access MLflow UI at: http://127.0.0.1:5001
```

---

## 9. ✅ Expected File Structure

After successful setup, you should have:

```
mlops-product-classification/
├── models/
│   ├── model.txt                    ← Trained model (should exist)
│   └── label_mapping.joblib          ← Label mappings (should exist)
├── data/
│   └── raw/
│       └── products.csv              ← Dataset (auto-generated if missing)
├── mlruns/                           ← MLflow tracking data
│   └── [experiment_id]/
│       └── [run_id]/
│           ├── artifacts/
│           ├── metrics/
│           └── params/
├── src/
│   ├── data/
│   ├── features/
│   ├── models/
│   └── inference/
└── verify_project.ps1               ← Verification script
```

---

## 10. ✅ Common Success Metrics

**Training Metrics (Good Performance):**
- Accuracy: > 0.70 (70%)
- F1 Score: > 0.70
- Precision: > 0.70
- Recall: > 0.70

**API Performance:**
- Response time: < 200ms per prediction
- Batch processing: < 500ms for 10 products
- Uptime: Server stays running without crashes

**Model File:**
- Size: Typically 100-500 KB
- Format: `.txt` file (LightGBM format)
- Contains: Trained model weights and structure

---

## ❌ What Errors Look Like

### Bad Output - Model Not Found:
```json
{
  "detail": "Model not loaded. Please train a model first."
}
```

### Bad Output - API Not Running:
```
Invoke-RestMethod: Unable to connect to the remote server
```

### Bad Output - Training Error:
```
ValueError: Number of classes should be specified...
```

---

## 🎯 Quick Success Checklist

Your project is working correctly if:

- [ ] Verification script shows all ✓ PASS
- [ ] API health returns `{"status": "healthy", "model_loaded": true}`
- [ ] Predictions return valid categories with confidence > 0.5
- [ ] Training completes without errors
- [ ] Model files exist in `models/` directory
- [ ] MLflow UI shows training runs
- [ ] No red error messages in console

---

## 📊 Performance Benchmarks

**Good Performance:**
- Training time: < 5 minutes (10K samples)
- Prediction latency: < 100ms
- Model accuracy: > 75%
- API response: < 200ms

**Acceptable Performance:**
- Training time: < 10 minutes
- Prediction latency: < 500ms
- Model accuracy: > 60%
- API response: < 1 second

---

If your outputs match these examples, your MLOps pipeline is working correctly! 🎉


