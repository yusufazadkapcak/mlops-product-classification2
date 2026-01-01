# 🔧 Fix: "Failed to fetch" Error

## Problem

You're seeing this error in Swagger UI:
```
Failed to fetch

Possible Reasons:
- CORS
- Network Failure
- URL scheme must be "http" or "https" for CORS request.
```

## Solution: The API Server is Not Running!

The error happens because **the API server needs to be started first**.

---

## ✅ Quick Fix: Start the API

### Option 1: Use the Script (Easiest)

```powershell
.\START_API_SIMPLE.ps1
```

### Option 2: Start Manually

Open a **PowerShell terminal** and run:

```powershell
cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

**Keep this terminal open!** The API will keep running.

---

## ✅ Verify API is Running

Once started, you should see:

```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://127.0.0.1:8000
```

### Test if it's working:

Open a **new terminal** and run:

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
```

You should get:
```json
{
  "status": "healthy",
  "model_loaded": true
}
```

---

## ✅ Now Use Swagger UI

1. **Keep the API running** in Terminal 1
2. Open your browser
3. Go to: **http://127.0.0.1:8000/docs**
4. Swagger UI should now work!

---

## 🔍 How to Check if API is Running

```powershell
try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 2
    Write-Host "✓ API is running!" -ForegroundColor Green
    Write-Host ($response | ConvertTo-Json)
} catch {
    Write-Host "✗ API is NOT running" -ForegroundColor Red
    Write-Host "Start it with: python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000"
}
```

---

## 📋 Step-by-Step Process

### Step 1: Start API (Terminal 1)
```powershell
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

### Step 2: Wait for Startup
Wait until you see:
```
INFO:     Uvicorn running on http://127.0.0.1:8000
```

### Step 3: Open Swagger UI (Browser)
Go to: **http://127.0.0.1:8000/docs**

### Step 4: Test Endpoints
- Click on any endpoint
- Click "Try it out"
- Fill in the form
- Click "Execute"

---

## ⚠️ Common Issues

### Issue 1: Port Already in Use

**Error:** `Address already in use`

**Solution:**
- Stop the existing server (Ctrl+C in the terminal running it)
- Or use a different port: `--port 8001`

### Issue 2: Model Not Found

**Error:** `Model not loaded`

**Solution:**
- Train the model first: `python src/main.py`
- Make sure `models/model.txt` exists

### Issue 3: Module Not Found

**Error:** `ModuleNotFoundError`

**Solution:**
- Install dependencies: `pip install -r requirements.txt`
- Make sure you're in the project directory

---

## ✅ Summary

**"Failed to fetch" = API server is not running**

**Fix:**
1. Start the API server in Terminal 1
2. Keep it running
3. Open Swagger UI in browser
4. Test endpoints

---

**The API must be running for Swagger UI to work!** 🚀




