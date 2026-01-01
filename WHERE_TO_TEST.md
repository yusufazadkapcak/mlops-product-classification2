# Where to Test Products - Quick Guide

## 🎯 For Testing Product Predictions

### Use the API Docs (Swagger UI)
**URL:** http://127.0.0.1:8000/docs

This is where you test products and get predictions!

**How to use:**
1. Open: http://127.0.0.1:8000/docs
2. Click on `/predict` (for single product) or `/predict/batch` (for multiple)
3. Click "Try it out"
4. Paste JSON in the "Request body" field
5. Click "Execute"
6. See predictions!

---

## 📊 For Viewing Training Results

### Use MLflow UI
**URL:** http://127.0.0.1:5001

This shows:
- Training runs and experiments
- Model metrics (accuracy, F1 score, etc.)
- Model parameters
- Model artifacts
- Comparison of different training runs

**What you can do:**
- View training history
- Compare model versions
- See metrics and charts
- Download model artifacts
- Register models

**What you CANNOT do:**
- ❌ Test new products (use API docs instead)
- ❌ Make predictions (use API docs instead)

---

## 🔄 Quick Reference

| What You Want | Where to Go | URL |
|--------------|-------------|-----|
| **Test product predictions** | API Docs | http://127.0.0.1:8000/docs |
| **View training results** | MLflow UI | http://127.0.0.1:5001 |
| **Health check** | API Health | http://127.0.0.1:8000/health |

---

## 📝 Example: Testing a Product

### Step 1: Go to API Docs
Open: http://127.0.0.1:8000/docs

### Step 2: Find `/predict` endpoint
Scroll down and click on it

### Step 3: Click "Try it out"

### Step 4: Paste this JSON:
```json
{
  "title": "Samsung Galaxy S24 Ultra",
  "price": 1299.99,
  "brand": "Samsung",
  "subcategory": "Electronics",
  "rating": 4.7,
  "reviews_count": 15000
}
```

### Step 5: Click "Execute"

### Step 6: See the prediction!

---

## 🎨 What You'll See in Each Interface

### API Docs (http://127.0.0.1:8000/docs)
- Interactive API testing
- Request/response examples
- Try predictions in real-time
- See prediction results immediately

### MLflow UI (http://127.0.0.1:5001)
- Training experiment list
- Metrics charts and graphs
- Model comparison tables
- Run details and parameters
- Model artifacts and files

---

## 💡 Pro Tip

**For testing products:** Always use http://127.0.0.1:8000/docs

**For analyzing training:** Use http://127.0.0.1:5001

They serve different purposes! 🚀



