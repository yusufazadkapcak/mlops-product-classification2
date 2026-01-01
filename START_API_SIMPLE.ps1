# Simple script to start the API server
# Run this script to start the API for testing

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Product Classification API  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if model exists
if (-not (Test-Path "models\model.txt")) {
    Write-Host "WARNING: Model not found!" -ForegroundColor Red
    Write-Host "Location: models\model.txt" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please train a model first:" -ForegroundColor Yellow
    Write-Host "  python src/main.py" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✓ Model found: models\model.txt" -ForegroundColor Green
Write-Host ""

# Check if port is already in use
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 1 -ErrorAction Stop
    Write-Host "⚠ WARNING: API is already running on port 8000!" -ForegroundColor Yellow
    Write-Host "If you want to restart, stop the existing server first." -ForegroundColor Yellow
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
Write-Host "=" * 50 -ForegroundColor Gray
Write-Host ""

# Start the API server
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000




