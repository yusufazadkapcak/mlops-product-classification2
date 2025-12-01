# Virtual Environment Setup Guide

## Quick Setup (PowerShell)

Run the setup script from the project root:

```powershell
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"
.\scripts\setup_venv.ps1
```

This script will:
1. Check if Python is installed
2. Create a virtual environment
3. Activate it
4. Upgrade pip, setuptools, and wheel
5. Install all project dependencies

## Manual Setup

### Step 1: Navigate to Project Directory

```powershell
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"
```

### Step 2: Create Virtual Environment

```powershell
python -m venv venv
```

### Step 3: Activate Virtual Environment

```powershell
.\venv\Scripts\Activate.ps1
```

If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then try activating again.

### Step 4: Upgrade pip

```powershell
python -m pip install --upgrade pip setuptools wheel
```

### Step 5: Install Dependencies

```powershell
pip install -r requirements.txt
```

## Verify Installation

Check that packages are installed:

```powershell
python -c "import pandas, numpy, lightgbm, mlflow, prefect, fastapi; print('All packages installed!')"
```

## Using the Virtual Environment

### Activate (each time you open a new terminal):

```powershell
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"
.\venv\Scripts\Activate.ps1
```

You should see `(venv)` at the start of your prompt.

### Deactivate:

```powershell
deactivate
```

## Troubleshooting

### "Python is not recognized"
- Make sure Python is installed
- Add Python to your PATH
- Or use full path: `C:\Python314\python.exe -m venv venv`

### "Execution Policy Error"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Cannot activate venv"
- Make sure you're in the project directory
- Check that `venv\Scripts\Activate.ps1` exists
- Try: `& ".\venv\Scripts\Activate.ps1"`

### "Packages not found after installation"
- Make sure venv is activated (you should see `(venv)`)
- Verify with: `where python` (should show venv path)
- Reinstall: `pip install -r requirements.txt`

## Next Steps

After setting up the virtual environment:

1. **Generate sample data:**
   ```powershell
   python scripts/generate_sample_data.py
   ```

2. **Start MLflow:**
   ```powershell
   python -m mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 127.0.0.1 --port 5000
   ```

3. **Run training:**
   ```powershell
   python src/main.py
   ```



