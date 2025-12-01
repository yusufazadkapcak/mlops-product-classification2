# Installation Instructions

## Step-by-Step Installation Guide

### 1. Navigate to Project Directory

Open PowerShell or Command Prompt and run:

```powershell
cd "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification"
```

Or if you're already in the OneDrive folder:
```powershell
cd mlops-product-classification
```

### 2. Verify You're in the Right Directory

Check that `requirements.txt` exists:
```powershell
dir requirements.txt
```

You should see the file listed.

### 3. Activate Virtual Environment (if not already activated)

If you have a virtual environment:
```powershell
.\venv\Scripts\Activate.ps1
```

If you get an execution policy error, run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. Upgrade pip

```powershell
python.exe -m pip install --upgrade pip
```

### 5. Install Requirements

```powershell
pip install -r requirements.txt
```

**Important**: Make sure you're in the directory that contains `requirements.txt`!

### Alternative: Use Full Path

If navigation is still problematic, you can use the full path:

```powershell
pip install -r "C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification\requirements.txt"
```

## Quick Check Commands

```powershell
# Check current directory
pwd

# List files in current directory
dir

# Check if requirements.txt exists
Test-Path requirements.txt

# Check Python version
python --version

# Check pip version
pip --version
```

## Troubleshooting

### Error: "Could not open requirements file"
- **Solution**: Make sure you're in the correct directory
- Run `dir requirements.txt` to verify the file exists
- Use the full path if needed

### Error: "pip is not recognized"
- **Solution**: Make sure Python is installed and in PATH
- Try `python -m pip` instead of just `pip`

### Error: "Execution Policy"
- **Solution**: Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Then try activating venv again



