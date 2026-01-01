# Simple Batch Prediction Test
# Just run this script - it's already correct!

Write-Host "Testing Batch Prediction..." -ForegroundColor Cyan
Write-Host ""

$batch = @(
    @{
        title = "iPhone 15 Pro Max 256GB Space Black"
        price = 1199.99
        brand = "Apple"
        subcategory = "Electronics"
        rating = 4.8
        reviews_count = 12500
    },
    @{
        title = "Nike Air Max Shoes"
        price = 129.99
        brand = "Nike"
        subcategory = "Clothing"
        rating = 4.6
        reviews_count = 8500
    }
) | ConvertTo-Json

Write-Host "Sending request..." -ForegroundColor Yellow
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://127.0.0.1:8000/predict/batch" -Method Post -Body $batch -ContentType "application/json"
    
    Write-Host "SUCCESS! Response:" -ForegroundColor Green
    Write-Host ""
    $response | ConvertTo-Json -Depth 10
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Total Processed: $($response.total_processed)" -ForegroundColor White
    Write-Host "  Processing Time: $($response.processing_time_ms) ms" -ForegroundColor White
    Write-Host ""
    Write-Host "  Predictions:" -ForegroundColor Cyan
    for ($i = 0; $i -lt $response.predictions.Count; $i++) {
        $pred = $response.predictions[$i]
        $conf = [math]::Round($pred.confidence * 100, 2)
        Write-Host "    $($i+1). $($pred.category) (confidence: $conf%)" -ForegroundColor White
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
}



