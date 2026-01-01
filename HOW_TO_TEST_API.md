# 🧪 How to Test Your API - Simple Instructions

## ✅ Your Model is Ready!

Your trained model exists at: `models/model.txt`

---

## 🚀 Step-by-Step Testing

### Step 1: Start the API (Open Terminal/PowerShell)

```powershell
cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

**Keep this terminal open!** You should see:
```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
```

---

### Step 2: Test the API (Open a NEW Terminal)

#### Option A: Use the Test Script (Easiest)

```powershell
cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
.\test_api_complete.ps1
```

This will test:
- ✓ Health check
- ✓ Root endpoint  
- ✓ Single prediction (Electronics)
- ✓ Single prediction (Clothing)
- ✓ Minimal data prediction
- ✓ Batch prediction

#### Option B: Test Manually (For Your Demo)

**1. Health Check:**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

**2. Single Prediction:**
```powershell
$body = @{
    title = "iPhone 15 Pro Max 256GB"
    price = 1199.99
    brand = "Apple"
    subcategory = "Electronics"
    rating = 4.8
    reviews_count = 12500
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

**3. Batch Prediction:**
```powershell
$batch = @(
    @{title = "Nike Air Max Shoes"; price = 129.99; brand = "Nike"},
    @{title = "Samsung 4K TV"; price = 799.99; brand = "Samsung"}
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

---

### Step 3: Test with Swagger UI (Best for Demo!)

1. Open your browser
2. Go to: **http://127.0.0.1:8000/docs**
3. You'll see interactive API documentation
4. Click on any endpoint (e.g., `/predict`)
5. Click "Try it out"
6. Enter test data
7. Click "Execute"
8. See the response!

---

## 📋 Quick Test Commands (Copy & Paste)

### Health Check
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

### Root Endpoint
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/"
```

### Single Prediction (One Line)
```powershell
$body = '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics","rating":4.8,"reviews_count":12500}'; Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

---

## 🎯 For Your Presentation Demo

### Recommended Demo Flow:

1. **Show Code** (VS Code)
   - Open `src/inference/api.py`
   - Show the prediction endpoint code
   - Show drift detection integration

2. **Start API** (Terminal 1)
   - Run the start command
   - Show the server starting
   - Show model loading

3. **Test with Swagger UI** (Browser)
   - Open http://127.0.0.1:8000/docs
   - Show the interactive documentation
   - Make a real prediction
   - Show the response with confidence scores

4. **Show Integrations**
   - Point out `build_features()` - Feature engineering
   - Point out `drift_detector` - Drift detection
   - Point out MLflow model loading

---

## ✅ Expected Results

### Health Check Response:
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

### Prediction Response:
```json
{
  "category": "Electronics",
  "confidence": 0.9245,
  "probabilities": {
    "Electronics": 0.9245,
    "Clothing": 0.0234,
    "Books": 0.0156,
    ...
  }
}
```

---

## 🐛 Troubleshooting

### API won't start
- Make sure port 8000 is not in use
- Check if you're in the correct directory
- Install dependencies: `pip install -r requirements.txt`

### Model not found
- Model exists, so this shouldn't happen
- But if it does, run: `python src/main.py` to train

### Connection refused
- Make sure API is running in Terminal 1
- Use `127.0.0.1` not `localhost`
- Wait a few seconds after starting

---

## 📝 Files You Created for Testing

1. **`test_api_complete.ps1`** - Comprehensive test script
2. **`START_AND_TEST_API.ps1`** - Start API and test
3. **`TEST_API_GUIDE.md`** - Detailed testing guide
4. **`HOW_TO_TEST_API.md`** - This file (quick reference)

---

**You're all set! Good luck with your demo! 🚀**




