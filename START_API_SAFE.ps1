# Safe API Starter - Kills any process on port 8000, then starts API
# Run this from the mlops-product-classification directory

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Safe API Starter" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Navigate to correct directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Join-Path $scriptDir "mlops-product-classification"

if (-not (Test-Path $projectDir)) {
    $projectDir = $scriptDir
}

Set-Location $projectDir
$env:PYTHONPATH = $projectDir

Write-Host "Directory: $projectDir" -ForegroundColor Yellow
Write-Host ""

# Step 1: Kill any process on port 8000
Write-Host "Step 1: Checking port 8000..." -ForegroundColor Cyan
$connections = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue

if ($connections) {
    Write-Host "  Found process(es) using port 8000. Stopping..." -ForegroundColor Yellow
    $connections | ForEach-Object {
        try {
            $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
            Write-Host "    Stopping PID: $($_.OwningProcess) ($($proc.ProcessName))" -ForegroundColor Yellow
            Stop-Process -Id $_.OwningProcess -Force -ErrorAction Stop
        } catch {
            Write-Host "    Could not stop PID: $($_.OwningProcess)" -ForegroundColor Red
        }
    }
    
    # Wait for port to be released
    Write-Host "  Waiting for port to be released..." -ForegroundColor Yellow
    $maxWait = 10
    $waited = 0
    while ($waited -lt $maxWait) {
        Start-Sleep -Seconds 1
        $waited++
        $stillRunning = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
        if (-not $stillRunning) {
            break
        }
    }
    
    if ($waited -ge $maxWait) {
        Write-Host "  ⚠ Port still in use after $maxWait seconds" -ForegroundColor Red
        Write-Host "  Try using a different port: --port 8001" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "  ✓ Port 8000 is now free" -ForegroundColor Green
} else {
    Write-Host "  ✓ Port 8000 is free" -ForegroundColor Green
}

Write-Host ""

# Step 2: Verify API files exist
Write-Host "Step 2: Verifying API files..." -ForegroundColor Cyan
if (-not (Test-Path "src\inference\api.py")) {
    Write-Host "  ✗ ERROR: Cannot find src\inference\api.py" -ForegroundColor Red
    Write-Host "  Current directory: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ API files found" -ForegroundColor Green
Write-Host ""

# Step 3: Start API
Write-Host "Step 3: Starting API server..." -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 API:        http://127.0.0.1:8000" -ForegroundColor Green
Write-Host "📚 Swagger UI: http://127.0.0.1:8000/docs" -ForegroundColor Green
Write-Host "📖 ReDoc:      http://127.0.0.1:8000/redoc" -ForegroundColor Green
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the server
python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000


