# Quick Start API - Handles all directory and path issues
# Just run this script and it will work!

Write-Host "🚀 Starting API Server..." -ForegroundColor Cyan
Write-Host ""

# Navigate to script directory (project root)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Set PYTHONPATH
$env:PYTHONPATH = $scriptDir

# Verify files
if (-not (Test-Path "src\inference\api.py")) {
    Write-Host "❌ ERROR: Cannot find src\inference\api.py" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Directory: $(Get-Location)" -ForegroundColor Green
Write-Host "✓ PYTHONPATH: $env:PYTHONPATH" -ForegroundColor Green
Write-Host ""

# Check if already running
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 1 -ErrorAction Stop
    Write-Host "⚠ API already running! Stop it first (Ctrl+C) or use different port." -ForegroundColor Yellow
    exit 0
} catch {
    # Good, port is free
}

Write-Host "Starting server..." -ForegroundColor Cyan
Write-Host "🌐 API:        http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "📚 Swagger UI: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

# Start the server
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000




