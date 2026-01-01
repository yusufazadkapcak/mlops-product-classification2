# 📋 Correct API Request Format

## 422 Error Fix Guide

If you get a **422 Unprocessable Content** error, it means the request body format is incorrect.

---

## ✅ Correct Request Format

### Required Field:
- **`title`** (string) - **REQUIRED** - Must be a string

### Optional Fields:
- `seller_id` (string or null)
- `brand` (string or null)
- `subcategory` (string or null)
- `price` (number/float or null)
- `rating` (number/float or null)
- `reviews_count` (integer or null)

---

## ✅ Correct JSON Examples

### Example 1: Full Request (All Fields)
```json
{
  "title": "iPhone 15 Pro Max 256GB",
  "seller_id": "SELLER_001",
  "brand": "Apple",
  "subcategory": "Electronics",
  "price": 1199.99,
  "rating": 4.8,
  "reviews_count": 12500
}
```

### Example 2: Minimum Request (Only Required Field)
```json
{
  "title": "Nike Running Shoes"
}
```

### Example 3: With Some Optional Fields
```json
{
  "title": "Samsung 4K Smart TV",
  "price": 899.99,
  "brand": "Samsung",
  "rating": 4.7
}
```

---

## ❌ Common Mistakes That Cause 422 Error

### 1. Missing Required Field "title"
```json
{
  "price": 99.99,
  "brand": "Nike"
}
```
**Error:** `title` is required!

### 2. Wrong Data Type for price (must be number, not string)
```json
{
  "title": "iPhone",
  "price": "1199.99"  ❌ Wrong - string instead of number
}
```
**Should be:**
```json
{
  "title": "iPhone",
  "price": 1199.99  ✅ Correct - number
}
```

### 3. Wrong Data Type for reviews_count (must be integer, not float)
```json
{
  "title": "iPhone",
  "reviews_count": 12500.5  ❌ Wrong - float instead of integer
}
```
**Should be:**
```json
{
  "title": "iPhone",
  "reviews_count": 12500  ✅ Correct - integer
}
```

### 4. Typo in Field Name
```json
{
  "titl": "iPhone",  ❌ Wrong - typo
  "price": 999.99
}
```
**Should be:**
```json
{
  "title": "iPhone",  ✅ Correct
  "price": 999.99
}
```

---

## 🔧 PowerShell Examples (Copy & Paste Ready)

### Minimal Request (Only Title)
```powershell
$body = @{
    title = "iPhone 15 Pro Max"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Full Request (All Fields)
```powershell
$body = @{
    title = "iPhone 15 Pro Max 256GB"
    seller_id = "SELLER_001"
    brand = "Apple"
    subcategory = "Electronics"
    price = 1199.99
    rating = 4.8
    reviews_count = 12500
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Request with Some Fields
```powershell
$body = @{
    title = "Nike Air Max Shoes"
    price = 129.99
    brand = "Nike"
    rating = 4.6
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

---

## 🌐 Swagger UI (Recommended - No Errors!)

The easiest way to test without errors is using Swagger UI:

1. Go to: **http://127.0.0.1:8000/docs**
2. Click on **POST /predict**
3. Click **"Try it out"**
4. The form will show you exactly what fields are needed
5. Fill in the fields (at minimum, just "title")
6. Click **"Execute"**

Swagger UI automatically formats the JSON correctly!

---

## 📝 Field Types Reference

| Field | Type | Required | Example |
|-------|------|----------|---------|
| `title` | string | ✅ **YES** | `"iPhone 15 Pro Max"` |
| `seller_id` | string \| null | ❌ No | `"SELLER_001"` or omit |
| `brand` | string \| null | ❌ No | `"Apple"` or omit |
| `subcategory` | string \| null | ❌ No | `"Electronics"` or omit |
| `price` | number (float) \| null | ❌ No | `1199.99` or omit |
| `rating` | number (float) \| null | ❌ No | `4.8` or omit |
| `reviews_count` | integer \| null | ❌ No | `12500` or omit |

---

## 🔍 How to Check Your Request

### In PowerShell, check your JSON before sending:
```powershell
$body = @{
    title = "iPhone 15 Pro Max"
    price = 1199.99
} | ConvertTo-Json

Write-Host "Request JSON:" -ForegroundColor Cyan
Write-Host $body
```

This will show you exactly what will be sent.

---

## ✅ Quick Test Commands

### Test 1: Minimal (Only Title)
```powershell
$body = '{"title":"iPhone 15 Pro Max"}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Test 2: With Price
```powershell
$body = '{"title":"iPhone 15 Pro Max","price":1199.99}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

### Test 3: Full Request
```powershell
$body = '{"title":"iPhone 15 Pro Max","price":1199.99,"brand":"Apple","subcategory":"Electronics","rating":4.8,"reviews_count":12500}'
Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $body -ContentType "application/json"
```

---

## 🎯 Summary

**To fix 422 error:**
1. ✅ Make sure `title` field is included (REQUIRED)
2. ✅ Use correct data types (numbers not strings for price/rating)
3. ✅ Use correct field names (no typos)
4. ✅ Use valid JSON format
5. ✅ Or use Swagger UI - it prevents all these errors!

---

**The easiest way:** Use Swagger UI at http://127.0.0.1:8000/docs - it validates everything for you! 🚀




