# PowerShell script for AWS deployment
# AWS MLOps Deployment Script

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AWS MLOps Deployment" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check AWS CLI
Write-Host "Checking AWS CLI..." -ForegroundColor Gray
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Host "❌ AWS CLI not found" -ForegroundColor Red
    Write-Host "Install from: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ AWS CLI found" -ForegroundColor Green

# Check AWS credentials
Write-Host "Checking AWS credentials..." -ForegroundColor Gray
try {
    $identity = aws sts get-caller-identity 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Not configured"
    }
    Write-Host "✅ AWS credentials configured" -ForegroundColor Green
    $accountId = (aws sts get-caller-identity --query Account --output text)
    Write-Host "   Account ID: $accountId" -ForegroundColor Gray
} catch {
    Write-Host "❌ AWS credentials not configured" -ForegroundColor Red
    Write-Host "Run: aws configure" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Menu
Write-Host "Select deployment option:" -ForegroundColor Cyan
Write-Host "1. Setup AWS resources (S3, ECR, ECS)" -ForegroundColor White
Write-Host "2. Build and push Docker image" -ForegroundColor White
Write-Host "3. Deploy to ECS Fargate" -ForegroundColor White
Write-Host "4. Full deployment (all steps)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host "Running setup script..." -ForegroundColor Yellow
        bash aws/scripts/setup-aws.sh
    }
    "2" {
        Write-Host "Building and pushing image..." -ForegroundColor Yellow
        bash aws/scripts/build-and-push.sh
    }
    "3" {
        Write-Host "Deploying to ECS..." -ForegroundColor Yellow
        bash aws/scripts/deploy-ecs.sh
    }
    "4" {
        Write-Host "Running full deployment..." -ForegroundColor Yellow
        bash aws/scripts/setup-aws.sh
        bash aws/scripts/build-and-push.sh
        bash aws/scripts/deploy-ecs.sh
    }
    default {
        Write-Host "Invalid choice" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

