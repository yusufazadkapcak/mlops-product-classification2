#!/bin/bash
# Deploy to AWS Elastic Beanstalk (Simpler alternative)

set -e

# Load configuration
if [ -f aws/aws-config.env ]; then
    source aws/aws-config.env
else
    echo "❌ Configuration file not found. Run setup-aws.sh first"
    exit 1
fi

echo "=========================================="
echo "Deploying to AWS Elastic Beanstalk"
echo "=========================================="
echo ""

# Check if EB CLI is installed
if ! command -v eb &> /dev/null; then
    echo "❌ Elastic Beanstalk CLI not found"
    echo "Install with: pip install awsebcli"
    exit 1
fi

# Initialize EB (if not already)
if [ ! -f .elasticbeanstalk/config.yml ]; then
    echo "Initializing Elastic Beanstalk..."
    eb init -p docker -r $AWS_REGION product-classifier
fi

# Update Dockerrun file with actual image
sed -i.bak "s/YOUR_ACCOUNT_ID/$AWS_ACCOUNT_ID/g" aws/elastic-beanstalk/Dockerrun.aws.json

# Create or update environment
echo "Creating/updating Elastic Beanstalk environment..."
eb create product-classifier-env \
    --instance-type t3.small \
    --envvars MLFLOW_TRACKING_URI=http://your-mlflow-endpoint:5000 \
    2>/dev/null || \
eb deploy

echo "✅ Deployment complete!"
echo ""
echo "Get your URL:"
echo "  eb status"
echo "  eb open"
echo ""


