# 🔧 Fix: 422 Error on Batch Prediction

## Problem

Getting **422 Unprocessable Content** error when calling `/predict/batch`

## Cause

The request body format is incorrect. The batch endpoint expects an **array** of product objects, not a single object.

---

## ✅ Correct Format

### Must be an ARRAY `[...]`, not an object `{...}`

```json
[
  {
    "title": "Product 1",
    "price": 99.99
  },
  {
    "title": "Product 2",
    "price": 199.99
  }
]
```

---

## ✅ PowerShell Examples

### Correct Way (Array)

```powershell
# Create array of products
$batch = @(
    @{
        title = "iPhone 15 Pro Max"
        price = 1199.99
        brand = "Apple"
    },
    @{
        title = "Nike Running Shoes"
        price = 129.99
        brand = "Nike"
    }
) | ConvertTo-Json -Depth 10

# Send request
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

### Wrong Way (Single Object)

```powershell
# ❌ WRONG - This is a single object, not an array
$batch = @{
    title = "iPhone"
    price = 999.99
} | ConvertTo-Json

# This will give 422 error!
```

---

## ✅ Quick Test (Copy & Paste)

```powershell
$batch = '[{"title":"iPhone 15"},{"title":"Nike Shoes"}]'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
```

---

## ✅ Using the Fixed Script

I've fixed the `TEST_BATCH_PREDICTION.ps1` script. Run it:

```powershell
.\TEST_BATCH_PREDICTION.ps1
```

---

## 🌐 Using Swagger UI (Easiest - No Errors!)

1. Go to: **http://127.0.0.1:8000/docs**
2. Click on **POST /predict/batch**
3. Click **"Try it out"**
4. Enter this in the request body:

```json
[
  {
    "title": "iPhone 15 Pro Max",
    "price": 1199.99,
    "brand": "Apple",
    "subcategory": "Electronics"
  },
  {
    "title": "Nike Running Shoes",
    "price": 129.99,
    "brand": "Nike",
    "subcategory": "Clothing"
  }
]
```

5. Click **"Execute"**

Swagger UI validates the format automatically!

---

## ⚠️ Common Mistakes

### 1. Not Using Array Brackets
```json
// ❌ WRONG
{
  "title": "Product 1"
}

// ✅ CORRECT
[
  {
    "title": "Product 1"
  }
]
```

### 2. Missing Title Field
```json
// ❌ WRONG - No title
[
  {
    "price": 99.99
  }
]

// ✅ CORRECT - Title is required
[
  {
    "title": "Product 1",
    "price": 99.99
  }
]
```

### 3. PowerShell ConvertTo-Json Depth Issue
```powershell
# ❌ WRONG - May not convert nested objects properly
$batch = @(...) | ConvertTo-Json

# ✅ CORRECT - Use -Depth parameter
$batch = @(...) | ConvertTo-Json -Depth 10
```

---

## 📋 Complete Working Example

```powershell
# Create batch array
$batchProducts = @(
    @{
        title = "Apple iPhone 15 Pro Max"
        price = 1199.99
        brand = "Apple"
        subcategory = "Electronics"
        rating = 4.8
        reviews_count = 12500
    },
    @{
        title = "Nike Air Max Running Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
        rating = 4.6
        reviews_count = 3500
    }
) | ConvertTo-Json -Depth 10

# Send request
$response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batchProducts -ContentType "application/json"

# Display results
$response.predictions | ForEach-Object {
    Write-Host "Category: $($_.category), Confidence: $([math]::Round($_.confidence*100,2))%"
}
```

---

## ✅ Summary

**422 Error = Wrong Request Format**

**Fix:**
1. Use array `[...]` not object `{...}`
2. Each product must have `title` field (required)
3. Use `ConvertTo-Json -Depth 10` in PowerShell
4. Or use Swagger UI - it prevents errors!

---

**The script is now fixed! Try: `.\TEST_BATCH_PREDICTION.ps1`** 🚀




