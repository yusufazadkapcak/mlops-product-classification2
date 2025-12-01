# Installing AWS CLI on Windows

## Method 1: MSI Installer (Recommended - Easiest)

### Step 1: Download the Installer

1. Go to: https://awscli.amazonaws.com/AWSCLIV2.msi
2. Or visit: https://aws.amazon.com/cli/ and click "Download the AWS CLI MSI installer for Windows (64-bit)"

### Step 2: Run the Installer

1. Double-click the downloaded `AWSCLIV2.msi` file
2. Follow the installation wizard
3. Click "Next" through all prompts
4. Click "Install" (may require administrator privileges)
5. Click "Finish" when done

### Step 3: Verify Installation

Open a **new** PowerShell or Command Prompt window and run:

```powershell
aws --version
```

You should see something like: `aws-cli/2.x.x Python/3.x.x Windows/10 exe/AMD64`

---

## Method 2: Using pip (Alternative)

If you have Python installed:

```powershell
pip install awscli
```

Then verify:
```powershell
aws --version
```

---

## Method 3: Using Chocolatey (If you have Chocolatey)

```powershell
choco install awscli
```

---

## After Installation

### Configure AWS CLI

Once installed, you need to configure it with your AWS credentials:

```powershell
aws configure
```

You'll be asked for:
1. **AWS Access Key ID**: Get this from AWS Console → IAM → Users → Security Credentials
2. **AWS Secret Access Key**: Get this when creating the access key
3. **Default region**: `us-east-1` (or your preferred region)
4. **Default output format**: `json`

### Get AWS Credentials

1. Go to: https://console.aws.amazon.com
2. Sign in to your AWS account
3. Go to **IAM** → **Users** → Your username
4. Click **Security credentials** tab
5. Click **Create access key**
6. Choose **Command Line Interface (CLI)**
7. Download or copy the **Access Key ID** and **Secret Access Key**

**Important**: Save these credentials securely - you won't be able to see the secret key again!

---

## Troubleshooting

### Issue: "aws is not recognized"

**Solution:**
1. Close and reopen your terminal/PowerShell
2. If still not working, add AWS CLI to PATH manually:
   - Default install location: `C:\Program Files\Amazon\AWSCLIV2\`
   - Add to PATH: System Properties → Environment Variables → Path

### Issue: Installation fails

**Solution:**
- Run PowerShell as Administrator
- Try the pip method instead
- Check Windows version compatibility

### Issue: Can't find credentials

**Solution:**
- Make sure you've run `aws configure`
- Verify credentials are correct
- Check credentials file location: `C:\Users\YourUsername\.aws\credentials`

---

## Quick Test

After installation and configuration, test it:

```powershell
aws sts get-caller-identity
```

This should return your AWS account ID if everything is set up correctly.

---

## Next Steps

Once AWS CLI is installed and configured:

1. Run the setup script:
   ```powershell
   cd mlops-product-classification
   .\aws\scripts\setup-aws.sh
   ```

2. Or use the PowerShell wrapper:
   ```powershell
   .\aws\scripts\deploy-aws.ps1
   ```

---

**Need help?** Check AWS CLI documentation: https://docs.aws.amazon.com/cli/

