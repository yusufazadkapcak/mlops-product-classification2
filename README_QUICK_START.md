# Quick Start Guide - MLOps Product Classification

## 🚀 Everything is Running!

Your MLOps pipeline is now operational. Here's what's available:

### 📊 Services Running

1. **API Server**: http://127.0.0.1:8000
   - Interactive API Docs: http://127.0.0.1:8000/docs
   - Health Check: http://127.0.0.1:8000/health

2. **MLflow UI**: http://127.0.0.1:5001
   - View training runs, metrics, and models

---

## 🧪 Test the API

### Option 1: Use the Test Script
```powershell
.\test_api.ps1
```

### Option 2: Use the Interactive Docs
1. Open: http://127.0.0.1:8000/docs
2. Click on `/predict` endpoint
3. Click "Try it out"
4. Enter product data:
```json
{
  "title": "iPhone 15 Pro Max",
  "price": 999.99,
  "brand": "Apple",
  "subcategory": "Electronics",
  "rating": 4.8,
  "reviews_count": 5000
}
```
5. Click "Execute"

### Option 3: Use PowerShell/curl
```powershell
$body = @{
    title = "Nike Air Max Shoes"
    price = 129.99
    brand = "Nike"
    subcategory = "Clothing"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

---

## 📝 API Endpoints

### 1. Health Check
```powershell
GET http://127.0.0.1:8000/health
```

### 2. Single Prediction
```powershell
POST http://127.0.0.1:8000/predict
Content-Type: application/json

{
  "title": "Product Title",
  "price": 99.99,
  "brand": "Brand Name",
  "subcategory": "Category",
  "rating": 4.5,
  "reviews_count": 1000
}
```

### 3. Batch Prediction
```powershell
POST http://127.0.0.1:8000/predict/batch
Content-Type: application/json

[
  {
    "title": "Product 1",
    "price": 99.99,
    "brand": "Brand 1"
  },
  {
    "title": "Product 2",
    "price": 199.99,
    "brand": "Brand 2"
  }
]
```

---

## 🔄 Restart Services

### Start API Only
```powershell
.\start_api_only.ps1
```

### Start MLflow UI Only
```powershell
.\start_mlflow_only.ps1
```

### Start Both (if port 5000 is free)
```powershell
.\start_all.ps1
```

---

## 🎯 Next Steps

1. **View Training Results**: Open http://127.0.0.1:5001 to see your model metrics
2. **Test Predictions**: Use the API docs at http://127.0.0.1:8000/docs
3. **Retrain Model**: Run `python train_simple.py` to train with new data
4. **Monitor Performance**: Check MLflow for experiment tracking

---

## 🐛 Troubleshooting

### Port Already in Use
- **Port 5000**: MLflow will automatically use port 5001
- **Port 8000**: Stop any other service using this port, or modify `run_api_simple.py` to use a different port

### Model Not Found
- Train a model first: `python train_simple.py`
- The model will be saved to `models/model.txt`

### API Not Responding
- Check if the server is running: `netstat -ano | findstr :8000`
- Restart the API: `.\start_api_only.ps1`

---

## 📚 Full Documentation

See `README.md` for complete project documentation.



