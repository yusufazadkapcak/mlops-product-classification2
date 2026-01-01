# Script to kill any process using port 8000
# Run this if you get "port already in use" error

Write-Host "Checking for processes on port 8000..." -ForegroundColor Cyan

$connections = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue

if ($connections) {
    Write-Host "Found process(es) using port 8000:" -ForegroundColor Yellow
    $connections | ForEach-Object {
        $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        Write-Host "  PID: $($_.OwningProcess) - $($process.ProcessName)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Stopping process(es)..." -ForegroundColor Yellow
    
    $connections | ForEach-Object {
        try {
            Stop-Process -Id $_.OwningProcess -Force -ErrorAction Stop
            Write-Host "✓ Stopped PID: $($_.OwningProcess)" -ForegroundColor Green
        } catch {
            Write-Host "✗ Could not stop PID: $($_.OwningProcess) - $_" -ForegroundColor Red
        }
    }
    
    Start-Sleep -Seconds 2
    
    # Verify
    $stillRunning = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
    if ($stillRunning) {
        Write-Host ""
        Write-Host "⚠ Some processes are still running. Try manually:" -ForegroundColor Yellow
        $stillRunning | ForEach-Object {
            Write-Host "  Stop-Process -Id $($_.OwningProcess) -Force" -ForegroundColor Cyan
        }
    } else {
        Write-Host ""
        Write-Host "✓ Port 8000 is now free!" -ForegroundColor Green
        Write-Host "You can now start the API." -ForegroundColor Cyan
    }
} else {
    Write-Host "✓ Port 8000 is free - no processes found." -ForegroundColor Green
}


