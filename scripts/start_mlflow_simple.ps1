# Simple PowerShell script to start MLflow UI
# This is the easiest way to start MLflow on Windows

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting MLflow UI" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "⚠️  Virtual environment not detected" -ForegroundColor Yellow
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    
    $venvPath = ".\venv\Scripts\Activate.ps1"
    if (Test-Path $venvPath) {
        & $venvPath
        Write-Host "✅ Virtual environment activated" -ForegroundColor Green
    } else {
        Write-Host "❌ Virtual environment not found at: $venvPath" -ForegroundColor Red
        Write-Host "Please create it first: python -m venv venv" -ForegroundColor Yellow
        exit 1
    }
}

# Check if MLflow is installed
Write-Host "Checking MLflow installation..." -ForegroundColor Gray
try {
    $mlflowVersion = python -c "import mlflow; print(mlflow.__version__)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MLflow is installed (version: $mlflowVersion)" -ForegroundColor Green
    } else {
        Write-Host "❌ MLflow is not installed" -ForegroundColor Red
        Write-Host "Installing MLflow..." -ForegroundColor Yellow
        pip install mlflow
    }
} catch {
    Write-Host "❌ Error checking MLflow: $_" -ForegroundColor Red
    exit 1
}

# Create mlruns directory if it doesn't exist
Write-Host "Creating mlruns directory..." -ForegroundColor Gray
New-Item -ItemType Directory -Force -Path "mlruns" | Out-Null
Write-Host "✅ mlruns directory ready" -ForegroundColor Green

# Display information
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "MLflow UI Information" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "URL:        http://127.0.0.1:5000" -ForegroundColor White
Write-Host "Tracking:   file:./mlruns" -ForegroundColor White
Write-Host "Port:       5000" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start MLflow UI
Write-Host "Starting MLflow UI..." -ForegroundColor Cyan
Write-Host ""

python -m mlflow ui --backend-store-uri file:./mlruns --default-artifact-root ./mlruns --host 127.0.0.1 --port 5000 --workers 1


