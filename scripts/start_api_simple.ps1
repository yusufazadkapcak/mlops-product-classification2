# Simple PowerShell script to start the FastAPI server without reload
# This avoids Windows socket issues

Write-Host "Starting FastAPI Inference Server (no reload)..." -ForegroundColor Cyan

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Start the API server without reload flag (more stable on Windows)
Write-Host "Server will be available at: http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "API docs will be at: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000




