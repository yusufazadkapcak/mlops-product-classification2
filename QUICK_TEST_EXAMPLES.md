# Quick Test Examples - Copy & Paste Ready

## Option 1: PowerShell (Recommended for Windows)

### Single Prediction
```powershell
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

### Health Check
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

### Batch Prediction
```powershell
$batch = @(
    @{
        title = "Nike Air Max 270 Running Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
    },
    @{
        title = "Samsung 55-inch 4K QLED Smart TV"
        price = 899.99
        brand = "Samsung"
        subcategory = "Electronics"
    }
) | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

---

## Option 2: curl (Correct Syntax)

### Single Prediction
```bash
curl -X POST "http://127.0.0.1:8000/predict" `
  -H "accept: application/json" `
  -H "Content-Type: application/json" `
  -d '{
    "title": "iPhone 15 Pro Max 256GB Space Black",
    "price": 1199.99,
    "brand": "Apple",
    "subcategory": "Electronics",
    "rating": 4.8,
    "reviews_count": 12500
  }'
```

### Health Check
```bash
curl -X GET "http://127.0.0.1:8000/health"
```

### Batch Prediction
```bash
curl -X POST "http://127.0.0.1:8000/predict/batch" `
  -H "accept: application/json" `
  -H "Content-Type: application/json" `
  -d '[
    {
      "title": "Nike Air Max 270 Running Shoes",
      "price": 129.99,
      "brand": "Nike",
      "subcategory": "Clothing"
    },
    {
      "title": "Samsung 55-inch 4K QLED Smart TV",
      "price": 899.99,
      "brand": "Samsung",
      "subcategory": "Electronics"
    }
  ]'
```

---

## Option 3: One-Line PowerShell (Easiest)

### Single Prediction
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics"}' -ContentType "application/json"
```

---

## Expected Response

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

---

## Quick Copy-Paste Commands

**Just copy and paste these into PowerShell:**

```powershell
# Test 1: Health Check
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"

# Test 2: Single Prediction
$body = '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics","rating":4.8,"reviews_count":12500}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```



