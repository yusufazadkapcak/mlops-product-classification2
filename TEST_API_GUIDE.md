# 🧪 API Testing Guide for Backend Engineer

## Quick Start: Test Your API

### Step 1: Check if Model Exists

The API needs a trained model. Check if it exists:

```powershell
Test-Path "models\model.txt"
```

If `False`, you need to train a model first (see Step 2).

---

### Step 2: Train Model (If Needed)

If you don't have a trained model, run:

```powershell
python src/main.py
```

This will:
- Generate sample data (if needed)
- Train the model
- Save it to `models/model.txt`

---

### Step 3: Start the API

Open a **new PowerShell terminal** and run:

```powershell
# Navigate to project directory
cd mlops-product-classification

# Start the API
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

You should see:
```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000
```

**Keep this terminal open!** The API is now running.

---

### Step 4: Test the API

Open a **different PowerShell terminal** and run the test script:

```powershell
cd mlops-product-classification
.\test_api_complete.ps1
```

Or test manually:

#### Test 1: Health Check
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

Expected output:
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

#### Test 2: Single Prediction
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

Expected output:
```json
{
  "category": "Electronics",
  "confidence": 0.9245,
  "probabilities": {
    "Electronics": 0.9245,
    "Clothing": 0.0234,
    ...
  }
}
```

#### Test 3: Batch Prediction
```powershell
$batch = @(
    @{
        title = "Nike Air Max Running Shoes"
        price = 129.99
        brand = "Nike"
    },
    @{
        title = "Samsung 4K Smart TV"
        price = 799.99
        brand = "Samsung"
    }
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

---

### Step 5: Test with Swagger UI (Recommended for Demo)

1. Open your browser
2. Go to: **http://127.0.0.1:8000/docs**
3. You'll see interactive API documentation
4. Click on `/predict` endpoint
5. Click "Try it out"
6. Enter test data:
```json
{
  "title": "iPhone 15 Pro Max",
  "price": 1199.99,
  "brand": "Apple",
  "subcategory": "Electronics",
  "rating": 4.8,
  "reviews_count": 12500
}
```
7. Click "Execute"
8. See the response!

---

## Quick Test Commands (Copy & Paste)

### Health Check
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

### Single Prediction (One-liner)
```powershell
$body = '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics","rating":4.8,"reviews_count":12500}'; Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Root Endpoint
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/"
```

---

## What to Show in Your Demo

### 1. **Start the API** (Terminal 1)
Show the startup process and model loading.

### 2. **Show Swagger UI** (Browser)
- Navigate to http://127.0.0.1:8000/docs
- Show the interactive documentation
- Demonstrate a prediction request

### 3. **Show Code** (VS Code/IDE)
- Show `src/inference/api.py` - Main API code
- Show `src/inference/drift_detection.py` - Design pattern
- Show `docker/Dockerfile.inference` - Deployment

### 4. **Run Tests** (Terminal 2)
Run the test script to show all endpoints working.

---

## Troubleshooting

### API won't start
- Check if port 8000 is already in use
- Make sure you're in the project directory
- Check if Python dependencies are installed: `pip install -r requirements.txt`

### Model not found error
- Train the model first: `python src/main.py`
- Check if `models/model.txt` exists

### Import errors
- Make sure you're using Python 3.10+
- Activate virtual environment if using one
- Install requirements: `pip install -r requirements.txt`

### Connection refused
- Make sure the API is running in another terminal
- Check the URL: `http://127.0.0.1:8000` (not localhost)

---

## Test Script Output Example

When you run `.\test_api_complete.ps1`, you should see:

```
========================================
  Product Classification API Testing   
========================================

Checking if API is running...
✓ API is running!

1. Testing Root Endpoint (GET /)...
   ✓ Root endpoint working
   Message: Product Classification API
   Version: 1.0.0

2. Testing Health Check (GET /health)...
   ✓ Health Check: healthy
   Model Loaded: True

3. Testing Single Prediction - Electronics...
   ✓ Prediction Successful!
   Product: iPhone 15 Pro Max
   Predicted Category: Electronics
   Confidence: 92.45%
   Top 3 Probabilities:
     - Electronics: 92.45%
     - Clothing: 2.34%
     - Books: 1.56%

...
```

---

## For Your Presentation

1. **Have the API running** before you start
2. **Show Swagger UI** - it's the most impressive
3. **Make a real prediction** during the demo
4. **Show the response** - highlight confidence and probabilities
5. **Mention integrations**:
   - Feature engineering (`build_features`)
   - MLflow model loading
   - Drift detection

---

**Good luck with your demo! 🚀**




