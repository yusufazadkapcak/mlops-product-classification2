# Fix: ModuleNotFoundError: No module named 'src'

## Problem
You're running the command from the **parent directory** instead of the **project directory**.

## Quick Fix (Choose One)

### Option 1: Use the Script (Easiest)
Run this from **anywhere**:
```powershell
.\START_API_FROM_ROOT.ps1
```

### Option 2: Navigate Manually
```powershell
# Navigate to the project directory
cd mlops-product-classification

# Set PYTHONPATH
$env:PYTHONPATH = (Get-Location)

# Start API
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
```

### Option 3: Use Existing Script
If you're already in the project directory (`mlops-product-classification`):
```powershell
.\QUICK_START_API.ps1
```

## Directory Structure
```
C:\Users\melis\OneDrive\mlops-product-classification\  ← You are here (WRONG)
└── mlops-product-classification\                      ← You need to be here (CORRECT)
    ├── src\
    │   └── inference\
    │       └── api.py
    ├── QUICK_START_API.ps1
    └── ...
```

## Verify You're in the Right Place
Run this command - you should see `src` folder:
```powershell
Test-Path "src\inference\api.py"
# Should return: True
```


