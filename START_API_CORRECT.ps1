# Correct script to start the API - handles directory issues
# This script ensures you're in the correct directory

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Product Classification API  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory (project root)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

Write-Host "Working directory: $scriptPath" -ForegroundColor Gray
Write-Host ""

# Verify we're in the correct directory
if (-not (Test-Path "src\inference\api.py")) {
    Write-Host "ERROR: Cannot find src\inference\api.py" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please navigate to the project root directory:" -ForegroundColor Yellow
    Write-Host "  cd C:\Users\melis\OneDrive\mlops-product-classification\mlops-product-classification" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✓ Found API file: src\inference\api.py" -ForegroundColor Green
Write-Host ""

# Check if model exists
if (-not (Test-Path "models\model.txt")) {
    Write-Host "WARNING: Model not found!" -ForegroundColor Yellow
    Write-Host "Location: models\model.txt" -ForegroundColor Gray
    Write-Host ""
    Write-Host "The API will try to load from MLflow, but training a model is recommended." -ForegroundColor Yellow
    Write-Host ""
}

# Set PYTHONPATH to current directory
$env:PYTHONPATH = $scriptPath

Write-Host "PYTHONPATH set to: $env:PYTHONPATH" -ForegroundColor Gray
Write-Host ""

# Check if port is already in use
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 1 -ErrorAction Stop
    Write-Host "⚠ WARNING: API is already running on port 8000!" -ForegroundColor Yellow
    Write-Host "If you want to restart, stop the existing server first (Ctrl+C)." -ForegroundColor Yellow
    Write-Host ""
    exit 0
} catch {
    # Port is free, continue
}

Write-Host "Starting API server..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Server will be available at:" -ForegroundColor Green
Write-Host "  API:        http://127.0.0.1:8000" -ForegroundColor Cyan
Write-Host "  Swagger UI: http://127.0.0.1:8000/docs" -ForegroundColor Cyan
Write-Host "  ReDoc:      http://127.0.0.1:8000/redoc" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""
Write-Host ("=" * 50) -ForegroundColor Gray
Write-Host ""

# Start the API server
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000




