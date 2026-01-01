# PowerShell script to deploy to Railway
# Railway Cloud Deployment Script

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Railway Cloud Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Railway CLI is installed
Write-Host "Checking Railway CLI installation..." -ForegroundColor Gray
try {
    $railwayVersion = railway --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Railway CLI is installed" -ForegroundColor Green
    } else {
        Write-Host "❌ Railway CLI not found" -ForegroundColor Red
        Write-Host "Installing Railway CLI..." -ForegroundColor Yellow
        Write-Host "Run: npm i -g @railway/cli" -ForegroundColor Yellow
        Write-Host "Or visit: https://railway.app" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Railway CLI not found" -ForegroundColor Red
    Write-Host "Install with: npm i -g @railway/cli" -ForegroundColor Yellow
    exit 1
}

# Check if logged in
Write-Host "Checking Railway login status..." -ForegroundColor Gray
railway whoami 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Not logged in to Railway" -ForegroundColor Yellow
    Write-Host "Logging in..." -ForegroundColor Yellow
    railway login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Login failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Logged in to Railway" -ForegroundColor Green

# Check if project is linked
Write-Host "Checking project link..." -ForegroundColor Gray
railway status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Project not linked" -ForegroundColor Yellow
    Write-Host "Linking project..." -ForegroundColor Yellow
    railway link
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to link project" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Project linked" -ForegroundColor Green

# Display current environment variables
Write-Host ""
Write-Host "Current environment variables:" -ForegroundColor Cyan
railway variables

# Ask for MLflow tracking URI
Write-Host ""
$mlflowUri = Read-Host "Enter MLflow Tracking URI (or press Enter to skip)"
if ($mlflowUri) {
    Write-Host "Setting MLFLOW_TRACKING_URI..." -ForegroundColor Yellow
    railway variables set MLFLOW_TRACKING_URI=$mlflowUri
    Write-Host "✅ MLFLOW_TRACKING_URI set" -ForegroundColor Green
}

# Deploy
Write-Host ""
Write-Host "Deploying to Railway..." -ForegroundColor Cyan
Write-Host "This may take a few minutes..." -ForegroundColor Gray
Write-Host ""

railway up

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✅ Deployment Successful!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Get your service URL:" -ForegroundColor Cyan
    Write-Host "  railway domain" -ForegroundColor White
    Write-Host ""
    Write-Host "View logs:" -ForegroundColor Cyan
    Write-Host "  railway logs" -ForegroundColor White
    Write-Host ""
    Write-Host "View dashboard:" -ForegroundColor Cyan
    Write-Host "  railway open" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "❌ Deployment Failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check logs for errors:" -ForegroundColor Yellow
    Write-Host "  railway logs" -ForegroundColor White
    exit 1
}


