# PowerShell script to start only MLflow UI

Write-Host "Starting MLflow UI..." -ForegroundColor Cyan
Write-Host ""

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Check if port 5000 is available, use 5001 if not
$port = 5000
$portInUse = netstat -ano | findstr ":$port "
if ($portInUse) {
    Write-Host "Port 5000 is in use. Using port 5001 instead..." -ForegroundColor Yellow
    $port = 5001
}

Write-Host "MLflow UI will be available at: http://127.0.0.1:$port" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port $port --workers 1

