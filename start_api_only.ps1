# PowerShell script to start only the API server

Write-Host "Starting FastAPI Inference Server..." -ForegroundColor Cyan
Write-Host ""

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Check if model exists
if (-not (Test-Path "models\model.txt")) {
    Write-Host "WARNING: Model not found!" -ForegroundColor Yellow
    Write-Host "The API will try to load from MLflow, but it's better to have a local model." -ForegroundColor Yellow
    Write-Host "Run: python train_simple.py to train a model" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Server will be available at: http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "API docs will be at: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

python run_api_simple.py


