# Fix for Installation Error

## Problem
You're getting: `BackendUnavailable: Cannot import 'setuptools.build_meta'`

## Solution

Run these commands in order:

```powershell
# 1. Make sure you're in the project directory
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"

# 2. Activate virtual environment
.\venv\Scripts\Activate.ps1

# 3. Install setuptools and wheel first (CRITICAL!)
pip install --upgrade setuptools wheel

# 4. Now install all requirements
pip install -r requirements.txt
```

## Alternative: Install packages one by one

If the above still fails, try installing in smaller batches:

```powershell
# Install build tools
pip install --upgrade setuptools wheel pip

# Install core dependencies
pip install pandas numpy scikit-learn

# Install ML tools
pip install lightgbm mlflow prefect

# Install API dependencies
pip install fastapi uvicorn pydantic

# Install testing
pip install pytest pytest-cov

# Install utilities
pip install python-dotenv requests pyyaml joblib category-encoders
```

## If you still have issues

Try creating a fresh virtual environment:

```powershell
# Deactivate current venv
deactivate

# Remove old venv
Remove-Item -Recurse -Force venv

# Create new venv
python -m venv venv

# Activate new venv
.\venv\Scripts\Activate.ps1

# Upgrade pip, setuptools, wheel
python -m pip install --upgrade pip setuptools wheel

# Install requirements
pip install -r requirements.txt
```



