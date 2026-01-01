#!/bin/bash
# Railway Cloud Deployment Script

echo ""
echo "========================================"
echo "Railway Cloud Deployment"
echo "========================================"
echo ""

# Check if Railway CLI is installed
echo "Checking Railway CLI installation..."
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found"
    echo "Installing Railway CLI..."
    echo "Run: npm i -g @railway/cli"
    echo "Or: curl -fsSL https://railway.app/install.sh | sh"
    exit 1
fi

echo "✅ Railway CLI is installed"

# Check if logged in
echo "Checking Railway login status..."
if ! railway whoami &> /dev/null; then
    echo "⚠️  Not logged in to Railway"
    echo "Logging in..."
    railway login
    if [ $? -ne 0 ]; then
        echo "❌ Login failed"
        exit 1
    fi
fi

echo "✅ Logged in to Railway"

# Check if project is linked
echo "Checking project link..."
if ! railway status &> /dev/null; then
    echo "⚠️  Project not linked"
    echo "Linking project..."
    railway link
    if [ $? -ne 0 ]; then
        echo "❌ Failed to link project"
        exit 1
    fi
fi

echo "✅ Project linked"

# Display current environment variables
echo ""
echo "Current environment variables:"
railway variables

# Ask for MLflow tracking URI
echo ""
read -p "Enter MLflow Tracking URI (or press Enter to skip): " mlflow_uri
if [ ! -z "$mlflow_uri" ]; then
    echo "Setting MLFLOW_TRACKING_URI..."
    railway variables set MLFLOW_TRACKING_URI="$mlflow_uri"
    echo "✅ MLFLOW_TRACKING_URI set"
fi

# Deploy
echo ""
echo "Deploying to Railway..."
echo "This may take a few minutes..."
echo ""

railway up

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✅ Deployment Successful!"
    echo "========================================"
    echo ""
    echo "Get your service URL:"
    echo "  railway domain"
    echo ""
    echo "View logs:"
    echo "  railway logs"
    echo ""
    echo "View dashboard:"
    echo "  railway open"
else
    echo ""
    echo "========================================"
    echo "❌ Deployment Failed"
    echo "========================================"
    echo ""
    echo "Check logs for errors:"
    echo "  railway logs"
    exit 1
fi


