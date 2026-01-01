# PowerShell script to run the complete pipeline
# Make sure you're in the project directory and venv is activated

Write-Host "=== MLOps Product Classification Pipeline ===" -ForegroundColor Cyan

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Check Python and pip
Write-Host "`nChecking Python installation..." -ForegroundColor Cyan
python --version
pip --version

# Check if pandas is installed
Write-Host "`nChecking if pandas is installed..." -ForegroundColor Cyan
python -c "import pandas; print(f'pandas version: {pandas.__version__}')"

# Generate sample data
Write-Host "`n=== Step 1: Generating Sample Data ===" -ForegroundColor Green
python scripts/generate_sample_data.py

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error generating sample data!" -ForegroundColor Red
    exit 1
}

Write-Host "`nSample data generated successfully!" -ForegroundColor Green




