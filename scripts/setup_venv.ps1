# PowerShell script to set up virtual environment
# Run this from the project root directory

Write-Host "=== Setting Up Virtual Environment ===" -ForegroundColor Cyan

# Get project root directory
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $projectRoot
Set-Location $projectRoot

Write-Host "Project directory: $projectRoot" -ForegroundColor Gray

# Check if venv already exists
if (Test-Path "venv") {
    Write-Host "`nVirtual environment already exists!" -ForegroundColor Yellow
    $response = Read-Host "Do you want to remove it and create a new one? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "Removing existing virtual environment..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force venv
    } else {
        Write-Host "Using existing virtual environment." -ForegroundColor Green
        Write-Host "`nTo activate it, run:" -ForegroundColor Cyan
        Write-Host "  .\venv\Scripts\Activate.ps1" -ForegroundColor White
        exit
    }
}

# Check Python version
Write-Host "`nChecking Python version..." -ForegroundColor Cyan
$pythonVersion = python --version
Write-Host "Found: $pythonVersion" -ForegroundColor Green

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install Python 3.10+ from https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

# Create virtual environment
Write-Host "`nCreating virtual environment..." -ForegroundColor Cyan
python -m venv venv

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to create virtual environment!" -ForegroundColor Red
    exit 1
}

Write-Host "Virtual environment created successfully!" -ForegroundColor Green

# Activate virtual environment
Write-Host "`nActivating virtual environment..." -ForegroundColor Cyan
& ".\venv\Scripts\Activate.ps1"

# Upgrade pip
Write-Host "`nUpgrading pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip setuptools wheel

# Install requirements
Write-Host "`nInstalling project dependencies..." -ForegroundColor Cyan
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
    Write-Host "`nVirtual environment is ready!" -ForegroundColor Green
    Write-Host "`nTo activate it in the future, run:" -ForegroundColor Cyan
    Write-Host "  .\venv\Scripts\Activate.ps1" -ForegroundColor White
    Write-Host "`nTo deactivate, run:" -ForegroundColor Cyan
    Write-Host "  deactivate" -ForegroundColor White
} else {
    Write-Host "`nERROR: Failed to install dependencies!" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Yellow
    exit 1
}




