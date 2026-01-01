# Correct curl Commands - Fixed!

## ❌ WRONG (What you tried):
```bash
curl -X POST 'http://127.0.0.1:8000/predict/batch' \
  -H 'Content-Type: application/json' \
  -d '$body = @{ title = "iPhone..." } | ConvertTo-Json'
```
**Problem:** Using PowerShell syntax in curl's `-d` parameter

---

## ✅ CORRECT Commands

### 1. Single Prediction (curl)
```bash
curl -X POST "http://127.0.0.1:8000/predict" ^
  -H "accept: application/json" ^
  -H "Content-Type: application/json" ^
  -d "{\"title\":\"iPhone 15 Pro Max 256GB Space Black\",\"price\":1199.99,\"brand\":\"Apple\",\"subcategory\":\"Electronics\",\"rating\":4.8,\"reviews_count\":12500}"
```

### 2. Batch Prediction (curl)
```bash
curl -X POST "http://127.0.0.1:8000/predict/batch" ^
  -H "accept: application/json" ^
  -H "Content-Type: application/json" ^
  -d "[{\"title\":\"iPhone 15 Pro Max\",\"price\":1199.99,\"brand\":\"Apple\",\"subcategory\":\"Electronics\"},{\"title\":\"Nike Shoes\",\"price\":129.99,\"brand\":\"Nike\",\"subcategory\":\"Clothing\"}]"
```

### 3. PowerShell (Easier - Recommended)
```powershell
# Single Prediction
$body = @{
    title = "iPhone 15 Pro Max 256GB Space Black"
    price = 1199.99
    brand = "Apple"
    subcategory = "Electronics"
    rating = 4.8
    reviews_count = 12500
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

```powershell
# Batch Prediction
$batch = @(
    @{
        title = "iPhone 15 Pro Max"
        price = 1199.99
        brand = "Apple"
        subcategory = "Electronics"
    },
    @{
        title = "Nike Air Max Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
    }
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

---

## Expected Response Format

### Single Prediction Response:
```json
{
  "category": "Electronics",
  "confidence": 0.9245,
  "probabilities": {
    "Electronics": 0.9245,
    "Clothing": 0.0234,
    "Home & Kitchen": 0.0156,
    ...
  }
}
```

### Batch Prediction Response:
```json
{
  "predictions": [
    {
      "category": "Electronics",
      "confidence": 0.9245,
      "probabilities": {...}
    },
    {
      "category": "Clothing",
      "confidence": 0.8567,
      "probabilities": {...}
    }
  ],
  "total_processed": 2,
  "processing_time_ms": 45.2
}
```

---

## Quick Test Commands (Copy-Paste Ready)

### PowerShell - Single:
```powershell
$body = '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics","rating":4.8,"reviews_count":12500}'; Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### PowerShell - Batch:
```powershell
$batch = '[{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics"},{"title":"Nike Shoes","price":129.99,"brand":"Nike","subcategory":"Clothing"}]'; Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```



