# PowerShell script to start the FastAPI server
# Windows-compatible version

Write-Host "Starting FastAPI Inference Server..." -ForegroundColor Cyan

# Change to script directory (project root)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptPath
Set-Location $projectRoot

Write-Host "Working directory: $projectRoot" -ForegroundColor Gray

# Check if venv is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".\venv\Scripts\Activate.ps1"
}

# Set PYTHONPATH
$env:PYTHONPATH = $projectRoot

# Start the API server using the launcher script
Write-Host "Server will be available at: http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "API docs will be at: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

python run_api.py
