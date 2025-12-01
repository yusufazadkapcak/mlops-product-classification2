# How to Use Swagger UI (API Docs)

## Access Swagger UI
Open: http://127.0.0.1:8000/docs

---

## For Batch Prediction (`/predict/batch`)

### Step 1: Click on `/predict/batch` endpoint

### Step 2: Click "Try it out"

### Step 3: In the "Request body" field, paste ONLY this JSON:

```json
[
  {
    "title": "iPhone 15 Pro Max 256GB Space Black",
    "price": 1199.99,
    "brand": "Apple",
    "subcategory": "Electronics",
    "rating": 4.8,
    "reviews_count": 12500
  },
  {
    "title": "Nike Air Max Shoes",
    "price": 129.99,
    "brand": "Nike",
    "subcategory": "Clothing",
    "rating": 4.6,
    "reviews_count": 8500
  }
```

### Step 4: Click "Execute"

### Step 5: See the response below

---

## For Single Prediction (`/predict`)

### Step 1: Click on `/predict` endpoint

### Step 2: Click "Try it out"

### Step 3: In the "Request body" field, paste ONLY this JSON:

```json
{
  "title": "iPhone 15 Pro Max 256GB Space Black",
  "price": 1199.99,
  "brand": "Apple",
  "subcategory": "Electronics",
  "rating": 4.8,
  "reviews_count": 12500
}
```

### Step 4: Click "Execute"

---

## ❌ Common Mistakes

### WRONG - Don't paste the curl command:
```json
curl -X POST "http://127.0.0.1:8000/predict/batch" ...
```

### WRONG - Don't paste PowerShell code:
```json
$batch = @{ title = "..." } | ConvertTo-Json
```

### ✅ CORRECT - Only paste the JSON data:
```json
[
  {
    "title": "iPhone 15 Pro Max",
    "price": 1199.99,
    "brand": "Apple",
    "subcategory": "Electronics"
  }
]
```

---

## Quick Copy-Paste JSON

### Batch Prediction (2 products):
```json
[
  {
    "title": "iPhone 15 Pro Max",
    "price": 1199.99,
    "brand": "Apple",
    "subcategory": "Electronics",
    "rating": 4.8,
    "reviews_count": 12500
  },
  {
    "title": "Nike Air Max Shoes",
    "price": 129.99,
    "brand": "Nike",
    "subcategory": "Clothing",
    "rating": 4.6,
    "reviews_count": 8500
  }
]
```

### Single Prediction:
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

---

## Expected Successful Response

After clicking "Execute", you should see:

**Response Code:** 200

**Response Body:**
```json
{
  "predictions": [
    {
      "category": "Electronics",
      "confidence": 0.9245,
      "probabilities": {
        "Electronics": 0.9245,
        "Clothing": 0.0234,
        ...
      }
    },
    {
      "category": "Clothing",
      "confidence": 0.8567,
      "probabilities": {
        "Clothing": 0.8567,
        "Sports & Outdoors": 0.0892,
        ...
      }
    }
  ],
  "total_processed": 2,
  "processing_time_ms": 45.2
}
```

---

## Tips

1. **Clear the field first** - Click "Clear" before pasting
2. **Use the Example Value** - Click "Example Value" to see a sample
3. **Check the Schema** - Click "Schema" to see required fields
4. **Only JSON** - The request body must be valid JSON, nothing else


