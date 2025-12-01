# PowerShell script to start MLflow server
# Windows-compatible version

Write-Host "Starting MLflow Server..." -ForegroundColor Cyan

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Create directories if they don't exist
New-Item -ItemType Directory -Force -Path "mlflow\artifacts" | Out-Null

# Start MLflow server
Write-Host "MLflow UI will be available at: http://127.0.0.1:5000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

python -m mlflow server --backend-store-uri sqlite:///mlflow.db --default-artifact-root ./mlflow/artifacts --host 127.0.0.1 --port 5000



