# 🔧 Fix: "ModuleNotFoundError: No module named 'src'"

## Problem

You're seeing this error:
```
ModuleNotFoundError: No module named 'src'
```

## Cause

You're running the command from the **wrong directory**. Python can't find the `src` module because you're not in the project root directory.

---

## ✅ Solution: Navigate to Correct Directory

### Step 1: Navigate to Project Root

You need to be in this directory:
```
C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
```

**In PowerShell:**
```powershell
cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
```

### Step 2: Verify You're in the Right Place

Check if the `src` directory exists:
```powershell
Test-Path "src\inference\api.py"
```

Should return: `True`

### Step 3: Start the API

Now run:
```powershell
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

---

## ✅ Quick Fix: Use the Correct Script

I've created a script that handles directory navigation automatically:

```powershell
.\START_API_CORRECT.ps1
```

This script:
- ✅ Automatically navigates to the correct directory
- ✅ Sets PYTHONPATH correctly
- ✅ Verifies files exist before starting
- ✅ Checks if API is already running

---

## 🔍 How to Check Your Current Directory

### Check where you are:
```powershell
Get-Location
```

### Check if you're in the right place:
```powershell
# Should return True
Test-Path "src\inference\api.py"
Test-Path "models\model.txt"
Test-Path "requirements.txt"
```

---

## 📋 Complete Correct Command Sequence

```powershell
# 1. Navigate to project root
cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification

# 2. Verify you're in the right place
Get-Location
# Should show: ...\mlops-product-classification\mlops-product-classification

# 3. Check files exist
Test-Path "src\inference\api.py"
# Should return: True

# 4. Set PYTHONPATH (optional but recommended)
$env:PYTHONPATH = Get-Location

# 5. Start the API
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

---

## 🎯 Directory Structure

Your project should look like this:
```
mlops-product-classification/
├── src/
│   └── inference/
│       └── api.py          ← API file
├── models/
│   └── model.txt           ← Model file
├── requirements.txt
├── START_API_CORRECT.ps1   ← Use this script!
└── ...
```

**You must be in the `mlops-product-classification` directory (the one containing `src`)**

---

## ⚠️ Common Mistake

**Wrong Directory:**
```
C:\Users\melis\OneDrive\mlops-product-classification
```
(This is the parent directory - wrong!)

**Correct Directory:**
```
C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification
```
(This contains the `src` folder - correct!)

---

## ✅ Summary

**Error:** `ModuleNotFoundError: No module named 'src'`

**Cause:** Running command from wrong directory

**Fix:**
1. Navigate to: `mlops-product-classification\mlops-product-classification`
2. Or use: `.\START_API_CORRECT.ps1`

---

**The script handles everything automatically!** 🚀




