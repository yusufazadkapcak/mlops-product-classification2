# Add AWS CLI to PATH permanently
# Run this script as Administrator

$awsPath = "$env:APPDATA\Python\Python314\Scripts"

# Check if path exists
if (Test-Path $awsPath) {
    Write-Host "Found AWS CLI at: $awsPath" -ForegroundColor Green
    
    # Get current PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    # Check if already in PATH
    if ($currentPath -notlike "*$awsPath*") {
        # Add to PATH
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$awsPath", "User")
        Write-Host "✅ Added AWS CLI to PATH permanently" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  Please close and reopen your terminal for changes to take effect" -ForegroundColor Yellow
    } else {
        Write-Host "✅ AWS CLI is already in PATH" -ForegroundColor Green
    }
} else {
    Write-Host "❌ AWS CLI Scripts directory not found" -ForegroundColor Red
    Write-Host "Expected location: $awsPath" -ForegroundColor Yellow
}


