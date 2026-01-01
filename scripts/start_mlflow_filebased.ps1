# PowerShell script to start MLflow UI with file-based tracking
# This avoids Windows socket issues

Write-Host "Starting MLflow UI (file-based tracking)..." -ForegroundColor Cyan

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Create mlruns directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "mlruns" | Out-Null

# Start MLflow UI (reads from file-based tracking)
Write-Host "MLflow UI will be available at: http://127.0.0.1:5000" -ForegroundColor Green
Write-Host "Tracking data stored in: ./mlruns" -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Use single worker to avoid Windows issues
python -m mlflow ui --backend-store-uri file:./mlruns --default-artifact-root ./mlruns --host 127.0.0.1 --port 5000 --workers 1



