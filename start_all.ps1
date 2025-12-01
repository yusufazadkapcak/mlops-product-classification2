# PowerShell script to start everything (API server and MLflow UI)
# Run this to start both services

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting MLOps Product Classification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Check if model exists
if (-not (Test-Path "models\model.txt")) {
    Write-Host "WARNING: Model not found!" -ForegroundColor Yellow
    Write-Host "You need to train a model first. Run: python train_simple.py" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Do you want to train the model now? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "Training model..." -ForegroundColor Cyan
        python train_simple.py
        Write-Host ""
    } else {
        Write-Host "Skipping training. Starting servers anyway..." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Starting services..." -ForegroundColor Green
Write-Host ""
# Check if port 5000 is available, use 5001 if not
$mlflowPort = 5000
$portInUse = netstat -ano | findstr ":5000 "
if ($portInUse) {
    Write-Host "Port 5000 is in use. MLflow will use port 5001 instead..." -ForegroundColor Yellow
    $mlflowPort = 5001
}

Write-Host "1. MLflow UI will be at: http://127.0.0.1:$mlflowPort" -ForegroundColor Cyan
Write-Host "2. API Server will be at: http://127.0.0.1:8000" -ForegroundColor Cyan
Write-Host "3. API Docs will be at: http://127.0.0.1:8000/docs" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop all services" -ForegroundColor Yellow
Write-Host ""

# Start MLflow UI in background
Write-Host "Starting MLflow UI on port $mlflowPort..." -ForegroundColor Green
$mlflowJob = Start-Job -ScriptBlock {
    param($port, $pwd)
    Set-Location $pwd
    python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port $port --workers 1
} -ArgumentList $mlflowPort, $PWD

# Wait a bit for MLflow to start
Start-Sleep -Seconds 3

# Start API server (this will block)
Write-Host "Starting API Server..." -ForegroundColor Green
Write-Host ""
python run_api_simple.py

# Cleanup: Stop MLflow job when API server stops
Stop-Job $mlflowJob
Remove-Job $mlflowJob

