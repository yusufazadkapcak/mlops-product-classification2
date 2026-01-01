# Quick Start API Script - Run from project root
# This script navigates to the correct directory and starts the API

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting Product Classification API" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Navigate to the correct project directory
$projectDir = Join-Path $scriptDir "mlops-product-classification"

if (-not (Test-Path $projectDir)) {
    Write-Host "Error: Project directory not found at: $projectDir" -ForegroundColor Red
    Write-Host "Please make sure you're in the correct location." -ForegroundColor Yellow
    exit 1
}

Write-Host "Navigating to: $projectDir" -ForegroundColor Yellow
Set-Location $projectDir

# Set PYTHONPATH
$env:PYTHONPATH = $projectDir
Write-Host "PYTHONPATH set to: $env:PYTHONPATH" -ForegroundColor Yellow
Write-Host ""

# Check if API is already running
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 2 -ErrorAction Stop
    Write-Host "⚠ API is already running on port 8000!" -ForegroundColor Yellow
    Write-Host "Please stop it first (Ctrl+C) or use a different port." -ForegroundColor Yellow
    exit 1
} catch {
    # API is not running, which is what we want
}

Write-Host "Starting API server..." -ForegroundColor Green
Write-Host "API will be available at: http://127.0.0.1:8000" -ForegroundColor Cyan
Write-Host "Swagger UI: http://127.0.0.1:8000/docs" -ForegroundColor Cyan
Write-Host "ReDoc: http://127.0.0.1:8000/redoc" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the API
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000


