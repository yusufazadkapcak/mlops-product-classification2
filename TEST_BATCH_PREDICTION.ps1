# Script to test batch prediction endpoint
# This tests the /predict/batch endpoint with multiple products

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Testing Batch Prediction Endpoint    " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if API is running
try {
    $null = Invoke-RestMethod -Uri "http://127.0.0.1:8000/health" -TimeoutSec 2 -ErrorAction Stop
    Write-Host "✓ API is running" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "✗ API is not running!" -ForegroundColor Red
    Write-Host "Please start the API first:" -ForegroundColor Yellow
    Write-Host "  .\QUICK_START_API.ps1" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# Create batch request with multiple products
Write-Host "Creating batch request with 4 products..." -ForegroundColor Yellow

$batchProducts = @(
    @{
        title = "Apple iPhone 15 Pro Max 256GB Space Black"
        seller_id = "SELLER_001"
        brand = "Apple"
        subcategory = "Smartphones"
        price = 1199.99
        rating = 4.8
        reviews_count = 12500
    },
    @{
        title = "Nike Air Max 270 Running Shoes Men's Size 10"
        seller_id = "SELLER_002"
        brand = "Nike"
        subcategory = "Footwear"
        price = 129.99
        rating = 4.6
        reviews_count = 3500
    },
    @{
        title = "The Great Gatsby Hardcover Novel"
        seller_id = "SELLER_003"
        brand = "Penguin Classics"
        subcategory = "Books"
        price = 14.99
        rating = 4.9
        reviews_count = 12000
    },
    @{
        title = "Samsung 55-inch 4K QLED Smart TV"
        seller_id = "SELLER_004"
        brand = "Samsung"
        subcategory = "Televisions"
        price = 899.99
        rating = 4.7
        reviews_count = 8900
    }
) | ConvertTo-Json -Depth 10

Write-Host ""
Write-Host "Sending batch prediction request..." -ForegroundColor Cyan
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batchProducts -ContentType "application/json"
    
    Write-Host "✓ Batch Prediction Successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Results" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Display results
    for ($i = 0; $i -lt $response.predictions.Count; $i++) {
        $pred = $response.predictions[$i]
        $productNum = $i + 1
        
        Write-Host "Product $productNum" -ForegroundColor Yellow
        Write-Host "  Predicted Category: $($pred.category)" -ForegroundColor Green
        Write-Host "  Confidence: $([math]::Round($pred.confidence * 100, 2))%" -ForegroundColor Cyan
        
        # Show top 3 probabilities
        Write-Host "  Top 3 Probabilities:" -ForegroundColor Gray
        $pred.probabilities.PSObject.Properties | Sort-Object Value -Descending | Select-Object -First 3 | ForEach-Object {
            Write-Host "    - $($_.Name): $([math]::Round($_.Value * 100, 2))%" -ForegroundColor DarkGray
        }
        Write-Host ""
    }
    
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Total Products Processed: $($response.predictions.Count)" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Calculate average confidence
    $avgConfidence = ($response.predictions | ForEach-Object { $_.confidence } | Measure-Object -Average).Average
    Write-Host "Average Confidence: $([math]::Round($avgConfidence * 100, 2))%" -ForegroundColor Cyan
    Write-Host ""
    
} catch {
    Write-Host "✗ Batch Prediction Failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $errorBody = $reader.ReadToEnd()
            Write-Host ""
            Write-Host "Error Details:" -ForegroundColor Yellow
            Write-Host $errorBody -ForegroundColor Red
        } catch {
            # Could not read error body
        }
    }
    
    Write-Host ""
    Write-Host "Make sure:" -ForegroundColor Yellow
    Write-Host "  1. API is running" -ForegroundColor Yellow
    Write-Host "  2. Request format is correct (array of ProductRequest objects)" -ForegroundColor Yellow
    Write-Host "  3. Each product has at least 'title' field (required)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Test complete!" -ForegroundColor Green
