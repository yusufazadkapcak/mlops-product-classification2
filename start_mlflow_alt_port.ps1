# PowerShell script to start MLflow UI on an alternative port (5001)

Write-Host "Starting MLflow UI on port 5001..." -ForegroundColor Cyan
Write-Host ""

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

Write-Host "MLflow UI will be available at: http://127.0.0.1:5001" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5001 --workers 1


