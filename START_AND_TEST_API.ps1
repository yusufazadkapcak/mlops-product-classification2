# Complete script to start API and run tests
# Run this script to start the API and test it

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting API and Running Tests       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if model exists
if (-not (Test-Path "models\model.txt")) {
    Write-Host "WARNING: Model not found!" -ForegroundColor Red
    Write-Host "Please train a model first:" -ForegroundColor Yellow
    Write-Host "  python src/main.py" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

Write-Host "✓ Model found: models/model.txt" -ForegroundColor Green
Write-Host ""

# Check if API is already running
Write-Host "Checking if API is already running..." -ForegroundColor Yellow
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 2 -ErrorAction Stop
    Write-Host "✓ API is already running!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "API is not running. Starting it now..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Starting API server..." -ForegroundColor Cyan
    Write-Host "Server will be available at: http://127.0.0.1:8000" -ForegroundColor Green
    Write-Host "API docs will be at: http://127.0.0.1:8000/docs" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please keep this window open!" -ForegroundColor Yellow
    Write-Host "Open a NEW terminal window to run tests." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    
    # Start the API server (this will block)
    python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000
    exit 0
}

# If API is running, run tests
Write-Host "Running API tests..." -ForegroundColor Cyan
Write-Host ""

# Run the test script
if (Test-Path "test_api_complete.ps1") {
    & ".\test_api_complete.ps1"
} else {
    Write-Host "Test script not found. Running basic tests..." -ForegroundColor Yellow
    Write-Host ""
    
    # Basic health check
    Write-Host "Testing health endpoint..." -ForegroundColor Yellow
    try {
        $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health"
        Write-Host "✓ Health Check: $($health.status)" -ForegroundColor Green
        Write-Host "  Model Loaded: $($health.model_loaded)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Health check failed: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Open http://127.0.0.1:8000/docs in your browser to test the API interactively!" -ForegroundColor Cyan
}




