# Comprehensive Project Verification Script
# This script checks if all components of the MLOps pipeline are working correctly

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MLOps Project Verification" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allTestsPassed = $true
$testResults = @()

# Function to add test result
function Add-TestResult {
    param($name, $passed, $message)
    $testResults += [PSCustomObject]@{
        Test = $name
        Status = if ($passed) { "✓ PASS" } else { "✗ FAIL" }
        Message = $message
    }
    if (-not $passed) {
        $script:allTestsPassed = $false
    }
}

# Test 1: Check Python Environment
Write-Host "[1/10] Checking Python Environment..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    if ($pythonVersion -match "Python 3") {
        Add-TestResult "Python Environment" $true "Python is installed: $pythonVersion"
    } else {
        Add-TestResult "Python Environment" $false "Python not found or wrong version"
    }
} catch {
    Add-TestResult "Python Environment" $false "Python not accessible"
}

# Test 2: Check Virtual Environment
Write-Host "[2/10] Checking Virtual Environment..." -ForegroundColor Yellow
if ($env:VIRTUAL_ENV) {
    Add-TestResult "Virtual Environment" $true "Virtual environment is activated: $env:VIRTUAL_ENV"
} else {
    Add-TestResult "Virtual Environment" $false "Virtual environment not activated. Run: .\venv\Scripts\Activate.ps1"
}

# Test 3: Check Required Files
Write-Host "[3/10] Checking Project Files..." -ForegroundColor Yellow
$requiredFiles = @(
    "requirements.txt",
    "train_simple.py",
    "run_api_simple.py",
    "src\data\load.py",
    "src\models\train.py",
    "src\inference\api.py"
)

$filesOk = $true
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $filesOk = $false
        Add-TestResult "Project Files" $false "Missing file: $file"
        break
    }
}
if ($filesOk) {
    Add-TestResult "Project Files" $true "All required files present"
}

# Test 4: Check Model Files
Write-Host "[4/10] Checking Model Files..." -ForegroundColor Yellow
if (Test-Path "models\model.txt") {
    $modelSize = (Get-Item "models\model.txt").Length
    Add-TestResult "Model File" $true "Model exists ($([math]::Round($modelSize/1KB, 2)) KB)"
} else {
    Add-TestResult "Model File" $false "Model not found. Run: python train_simple.py"
}

if (Test-Path "models\label_mapping.joblib") {
    Add-TestResult "Label Mapping" $true "Label mapping file exists"
} else {
    Add-TestResult "Label Mapping" $false "Label mapping not found"
}

# Test 5: Check Data Files
Write-Host "[5/10] Checking Data Files..." -ForegroundColor Yellow
$dataFiles = Get-ChildItem "data\raw\*.csv" -ErrorAction SilentlyContinue
if ($dataFiles) {
    $dataCount = (Import-Csv $dataFiles[0].FullName | Measure-Object).Count
    Add-TestResult "Data Files" $true "Found $($dataFiles.Count) CSV file(s) with ~$dataCount rows"
} else {
    Add-TestResult "Data Files" $false "No data files found (will auto-generate on training)"
}

# Test 6: Check MLflow Runs
Write-Host "[6/10] Checking MLflow Tracking..." -ForegroundColor Yellow
if (Test-Path "mlruns") {
    $experiments = Get-ChildItem "mlruns" -Directory | Where-Object { $_.Name -ne "0" }
    if ($experiments) {
        $runCount = 0
        foreach ($exp in $experiments) {
            $runs = Get-ChildItem "$($exp.FullName)" -Directory -ErrorAction SilentlyContinue
            $runCount += ($runs | Measure-Object).Count
        }
        Add-TestResult "MLflow Tracking" $true "Found $runCount training run(s)"
    } else {
        Add-TestResult "MLflow Tracking" $false "No training runs found"
    }
} else {
    Add-TestResult "MLflow Tracking" $false "MLflow directory not found"
}

# Test 7: Check API Server
Write-Host "[7/10] Checking API Server..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get -TimeoutSec 3 -ErrorAction Stop
    if ($health.status -eq "healthy") {
        Add-TestResult "API Server" $true "API server is running and healthy"
    } else {
        Add-TestResult "API Server" $false "API server responded but status is not healthy"
    }
} catch {
    Add-TestResult "API Server" $false "API server not responding. Start it with: .\start_api_only.ps1"
}

# Test 8: Test API Prediction
Write-Host "[8/10] Testing API Prediction..." -ForegroundColor Yellow
try {
    $testProduct = @{
        title = "Test Product iPhone 15"
        price = 999.99
        brand = "Apple"
        subcategory = "Electronics"
        rating = 4.8
        reviews_count = 5000
    } | ConvertTo-Json

    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $testProduct -ContentType "application/json" -TimeoutSec 5 -ErrorAction Stop
    if ($prediction.category) {
        $confidence = [math]::Round($prediction.confidence * 100, 2)
        Add-TestResult "API Prediction" $true "Prediction successful: $($prediction.category) (confidence: $confidence%)"
    } else {
        Add-TestResult "API Prediction" $false "Prediction returned but no category"
    }
} catch {
    Add-TestResult "API Prediction" $false "Prediction failed: $($_.Exception.Message)"
}

# Test 9: Test Batch Prediction
Write-Host "[9/10] Testing Batch Prediction..." -ForegroundColor Yellow
try {
    $batchProducts = @(
        @{ title = "Nike Shoes"; price = 129.99; brand = "Nike"; subcategory = "Clothing" },
        @{ title = "Samsung TV"; price = 799.99; brand = "Samsung"; subcategory = "Electronics" }
    ) | ConvertTo-Json

    $batchResult = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batchProducts -ContentType "application/json" -TimeoutSec 5 -ErrorAction Stop
    if ($batchResult.predictions -and $batchResult.predictions.Count -eq 2) {
        Add-TestResult "Batch Prediction" $true "Batch prediction successful for 2 products"
    } else {
        Add-TestResult "Batch Prediction" $false "Batch prediction returned unexpected result"
    }
} catch {
    Add-TestResult "Batch Prediction" $false "Batch prediction failed: $($_.Exception.Message)"
}

# Test 10: Check MLflow UI
Write-Host "[10/10] Checking MLflow UI..." -ForegroundColor Yellow
try {
    $mlflowResponse = Invoke-WebRequest -Uri "http://127.0.0.1:5001" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
    if ($mlflowResponse.StatusCode -eq 200) {
        Add-TestResult "MLflow UI" $true "MLflow UI is accessible on port 5001"
    } else {
        Add-TestResult "MLflow UI" $false "MLflow UI returned status code: $($mlflowResponse.StatusCode)"
    }
} catch {
    # Try port 5000 as well
    try {
        $mlflowResponse = Invoke-WebRequest -Uri "http://127.0.0.1:5000" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
        Add-TestResult "MLflow UI" $true "MLflow UI is accessible on port 5000"
    } catch {
        Add-TestResult "MLflow UI" $false "MLflow UI not accessible. Start it with: .\start_mlflow_only.ps1"
    }
}

# Print Results
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICATION RESULTS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

foreach ($result in $testResults) {
    $color = if ($result.Status -eq "✓ PASS") { "Green" } else { "Red" }
    Write-Host "$($result.Status) - $($result.Test)" -ForegroundColor $color
    if ($result.Message) {
        Write-Host "  → $($result.Message)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

if ($allTestsPassed) {
    Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "Your MLOps pipeline is working correctly!" -ForegroundColor Green
} else {
    Write-Host "✗ SOME TESTS FAILED" -ForegroundColor Red
    Write-Host "Please fix the issues above and run this script again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Quick Links:" -ForegroundColor Cyan
Write-Host "  • API Docs: http://127.0.0.1:8000/docs" -ForegroundColor Yellow
Write-Host "  • MLflow UI: http://127.0.0.1:5001" -ForegroundColor Yellow
Write-Host ""


