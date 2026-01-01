# Simple Example - Test Your API
# Run this to see what a successful API response looks like

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "API Test Example" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Example 1: Health Check
Write-Host "Example 1: Health Check" -ForegroundColor Yellow
Write-Host "Request: GET http://127.0.0.1:8000/health" -ForegroundColor Gray
Write-Host ""

try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -Method Get
    Write-Host "Response:" -ForegroundColor Green
    $health | ConvertTo-Json
    Write-Host ""
} catch {
    Write-Host "ERROR: API server not running!" -ForegroundColor Red
    Write-Host "Start it with: .\start_api_only.ps1" -ForegroundColor Yellow
    Write-Host ""
    exit
}

Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""

# Example 2: Single Prediction
Write-Host "Example 2: Single Product Prediction" -ForegroundColor Yellow
Write-Host "Request: POST http://127.0.0.1:8000/predict" -ForegroundColor Gray
Write-Host ""

$exampleProduct = @{
    title = "iPhone 15 Pro Max 256GB Space Black"
    price = 1199.99
    brand = "Apple"
    subcategory = "Electronics"
    rating = 4.8
    reviews_count = 12500
}

Write-Host "Input Product:" -ForegroundColor Cyan
$exampleProduct | ConvertTo-Json
Write-Host ""

Write-Host "Response:" -ForegroundColor Green
try {
    $prediction = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict" -Method Post -Body ($exampleProduct | ConvertTo-Json) -ContentType "application/json"
    
    $prediction | ConvertTo-Json -Depth 10
    
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Predicted Category: $($prediction.category)" -ForegroundColor White
    Write-Host "  Confidence: $([math]::Round($prediction.confidence * 100, 2))%" -ForegroundColor White
    Write-Host ""
    Write-Host "  Top 3 Probabilities:" -ForegroundColor Cyan
    $prediction.probabilities.PSObject.Properties | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object {
        $percent = [math]::Round($_.Value * 100, 2)
        Write-Host "    • $($_.Name): $percent%" -ForegroundColor Gray
    }
} catch {
    Write-Host "ERROR: Prediction failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""

# Example 3: Batch Prediction
Write-Host "Example 3: Batch Prediction (Multiple Products)" -ForegroundColor Yellow
Write-Host "Request: POST http://127.0.0.1:8000/predict/batch" -ForegroundColor Gray
Write-Host ""

$exampleBatch = @(
    @{
        title = "Nike Air Max 270 Running Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
        rating = 4.6
        reviews_count = 8500
    },
    @{
        title = "Samsung 55-inch 4K QLED Smart TV"
        price = 899.99
        brand = "Samsung"
        subcategory = "Electronics"
        rating = 4.7
        reviews_count = 12000
    },
    @{
        title = "KitchenAid Stand Mixer Professional"
        price = 449.99
        brand = "KitchenAid"
        subcategory = "Home & Kitchen"
        rating = 4.9
        reviews_count = 15000
    }
)

Write-Host "Input Products (3 items):" -ForegroundColor Cyan
$exampleBatch | ConvertTo-Json -Depth 5
Write-Host ""

Write-Host "Response:" -ForegroundColor Green
try {
    $batchResult = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body ($exampleBatch | ConvertTo-Json -Depth 5) -ContentType "application/json"
    
    $batchResult | ConvertTo-Json -Depth 10
    
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Total Processed: $($batchResult.total_processed)" -ForegroundColor White
    Write-Host "  Processing Time: $($batchResult.processing_time_ms) ms" -ForegroundColor White
    Write-Host ""
    Write-Host "  Predictions:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $batchResult.predictions.Count; $i++) {
        $pred = $batchResult.predictions[$i]
        $conf = [math]::Round($pred.confidence * 100, 2)
        Write-Host "    $($i+1). $($pred.category) (confidence: $conf%)" -ForegroundColor Gray
    }
} catch {
    Write-Host "ERROR: Batch prediction failed!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Example Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Try more examples at: http://127.0.0.1:8000/docs" -ForegroundColor Yellow
Write-Host ""



