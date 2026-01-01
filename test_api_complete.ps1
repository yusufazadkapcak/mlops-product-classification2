# Comprehensive API Testing Script for Backend Engineer Demo
# This script tests all API endpoints

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Product Classification API Testing   " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if API is running
Write-Host "Checking if API is running..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 3
    Write-Host "✓ API is running!" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ API is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start the API first:" -ForegroundColor Yellow
    Write-Host "  python -m uvicorn src.inference.api:app --host 127.0.0.1 --port 8000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Or use:" -ForegroundColor Yellow
    Write-Host "  .\start_api_only.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Test 1: Root Endpoint
Write-Host "1. Testing Root Endpoint (GET /)..." -ForegroundColor Yellow
try {
    $root = Invoke-RestMethod -Uri "http://127.0.0.1:8000/" -Method Get
    Write-Host "   ✓ Root endpoint working" -ForegroundColor Green
    Write-Host "   Message: $($root.message)" -ForegroundColor Gray
    Write-Host "   Version: $($root.version)" -ForegroundColor Gray
} catch {
    Write-Host "   ✗ Root endpoint failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 2: Health Check
Write-Host "2. Testing Health Check (GET /health)..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get
    Write-Host "   ✓ Health Check: $($health.status)" -ForegroundColor Green
    Write-Host "   Model Loaded: $($health.model_loaded)" -ForegroundColor Green
    if (-not $health.model_loaded) {
        Write-Host "   ⚠ WARNING: Model not loaded!" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ✗ Health Check Failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 3: Single Prediction - Electronics
Write-Host "3. Testing Single Prediction - Electronics..." -ForegroundColor Yellow
$testProduct1 = @{
    title = "Apple iPhone 15 Pro Max 256GB Space Black"
    seller_id = "SELLER_001"
    brand = "Apple"
    subcategory = "Smartphones"
    price = 1199.99
    rating = 4.8
    reviews_count = 12500
} | ConvertTo-Json

try {
    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $testProduct1 -ContentType "application/json"
    Write-Host "   ✓ Prediction Successful!" -ForegroundColor Green
    Write-Host "   Product: iPhone 15 Pro Max" -ForegroundColor Cyan
    Write-Host "   Predicted Category: $($prediction.category)" -ForegroundColor Cyan
    Write-Host "   Confidence: $([math]::Round($prediction.confidence * 100, 2))%" -ForegroundColor Cyan
    Write-Host "   Top 3 Probabilities:" -ForegroundColor Cyan
    $prediction.probabilities.PSObject.Properties | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object {
        Write-Host "     - $($_.Name): $([math]::Round($_.Value * 100, 2))%" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ Prediction Failed: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "   Error Details: $responseBody" -ForegroundColor Red
        } catch {}
    }
}

Write-Host ""

# Test 4: Single Prediction - Clothing
Write-Host "4. Testing Single Prediction - Clothing..." -ForegroundColor Yellow
$testProduct2 = @{
    title = "Nike Air Max 270 Running Shoes Men's Size 10"
    seller_id = "SELLER_002"
    brand = "Nike"
    subcategory = "Footwear"
    price = 129.99
    rating = 4.6
    reviews_count = 3500
} | ConvertTo-Json

try {
    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $testProduct2 -ContentType "application/json"
    Write-Host "   ✓ Prediction Successful!" -ForegroundColor Green
    Write-Host "   Product: Nike Air Max 270" -ForegroundColor Cyan
    Write-Host "   Predicted Category: $($prediction.category)" -ForegroundColor Cyan
    Write-Host "   Confidence: $([math]::Round($prediction.confidence * 100, 2))%" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ Prediction Failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 5: Single Prediction - Minimal Data (Optional fields)
Write-Host "5. Testing Single Prediction - Minimal Data (only title)..." -ForegroundColor Yellow
$testProduct3 = @{
    title = "Python Programming Cookbook Advanced Recipes"
} | ConvertTo-Json

try {
    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body $testProduct3 -ContentType "application/json"
    Write-Host "   ✓ Prediction Successful with minimal data!" -ForegroundColor Green
    Write-Host "   Product: Python Programming Cookbook" -ForegroundColor Cyan
    Write-Host "   Predicted Category: $($prediction.category)" -ForegroundColor Cyan
    Write-Host "   Confidence: $([math]::Round($prediction.confidence * 100, 2))%" -ForegroundColor Cyan
} catch {
    Write-Host "   ✗ Prediction Failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 6: Batch Prediction
Write-Host "6. Testing Batch Prediction..." -ForegroundColor Yellow
$batchProducts = @(
    @{
        title = "Samsung 55-inch 4K QLED Smart TV"
        brand = "Samsung"
        subcategory = "Electronics"
        price = 899.99
        rating = 4.7
        reviews_count = 8900
    },
    @{
        title = "Levi's 501 Original Fit Jeans"
        brand = "Levi's"
        subcategory = "Clothing"
        price = 79.99
        rating = 4.5
        reviews_count = 5600
    },
    @{
        title = "The Great Gatsby Novel Hardcover"
        brand = "Penguin Classics"
        subcategory = "Books"
        price = 14.99
        rating = 4.9
        reviews_count = 12000
    }
) | ConvertTo-Json -Depth 10

try {
    $batchPredictions = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batchProducts -ContentType "application/json"
    Write-Host "   ✓ Batch Prediction Successful!" -ForegroundColor Green
    Write-Host "   Processed $($batchPredictions.predictions.Count) products" -ForegroundColor Cyan
    Write-Host ""
    $batchPredictions.predictions | ForEach-Object {
        Write-Host "     - Category: $($_.category)" -ForegroundColor Cyan
        Write-Host "       Confidence: $([math]::Round($_.confidence * 100, 2))%" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ✗ Batch Prediction Failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  API Testing Complete!                 " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Access API Documentation:" -ForegroundColor Yellow
Write-Host "  Swagger UI: http://127.0.0.1:8000/docs" -ForegroundColor Cyan
Write-Host "  ReDoc:      http://127.0.0.1:8000/redoc" -ForegroundColor Cyan
Write-Host ""




