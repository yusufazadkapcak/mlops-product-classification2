# PowerShell script to test the API

Write-Host "Testing Product Classification API..." -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "1. Testing Health Endpoint..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get
    Write-Host "   ✓ Health Check: $($health.status)" -ForegroundColor Green
    Write-Host "   Model Loaded: $($health.model_loaded)" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Health Check Failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Single Prediction
Write-Host "2. Testing Single Prediction..." -ForegroundColor Yellow
$testProduct = @{
    title = "iPhone 15 Pro Max 256GB"
    price = 999.99
    brand = "Apple"
    subcategory = "Electronics"
    rating = 4.8
    reviews_count = 5000
} | ConvertTo-Json

try {
    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $testProduct -ContentType "application/json"
    Write-Host "   ✓ Prediction Successful!" -ForegroundColor Green
    Write-Host "   Predicted Category: $($prediction.category)" -ForegroundColor Cyan
    Write-Host "   Confidence: $([math]::Round($prediction.confidence * 100, 2))%" -ForegroundColor Cyan
    Write-Host "   Top Probabilities:" -ForegroundColor Cyan
    $prediction.probabilities.PSObject.Properties | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object {
        Write-Host "     - $($_.Name): $([math]::Round($_.Value * 100, 2))%" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ Prediction Failed: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "   Error Details: $responseBody" -ForegroundColor Red
    }
}

Write-Host ""

# Test 3: Batch Prediction
Write-Host "3. Testing Batch Prediction..." -ForegroundColor Yellow
$batchProducts = @(
    @{
        title = "Nike Air Max Running Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
    },
    @{
        title = "Samsung 4K Smart TV 55 inch"
        price = 799.99
        brand = "Samsung"
        subcategory = "Electronics"
    }
) | ConvertTo-Json

try {
    $batchPredictions = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batchProducts -ContentType "application/json"
    Write-Host "   ✓ Batch Prediction Successful!" -ForegroundColor Green
    Write-Host "   Processed $($batchPredictions.predictions.Count) products" -ForegroundColor Cyan
    $batchPredictions.predictions | ForEach-Object {
        Write-Host "     - $($_.category) (confidence: $([math]::Round($_.confidence * 100, 2))%)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ Batch Prediction Failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "API Testing Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access API Docs at: http://127.0.0.1:8000/docs" -ForegroundColor Yellow
Write-Host "Access MLflow UI at: http://127.0.0.1:5001" -ForegroundColor Yellow


