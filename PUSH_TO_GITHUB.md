# Push Project to GitHub - Quick Guide

## Step 1: Configure Git (First Time Only)

You need to set your name and email for Git:

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

**Example:**
```powershell
git config --global user.name "Melis"
git config --global user.email "melis@example.com"
```

---

## Step 2: Create Initial Commit

```powershell
git commit -m "Initial commit: MLOps Product Classification Project"
```

---

## Step 3: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `mlops-product-classification`
3. Description: "MLOps Product Classification Project"
4. Choose Public or Private
5. **DO NOT** check "Initialize with README" (we already have files)
6. Click **"Create repository"**

---

## Step 4: Add Remote and Push

After creating the repository, run these commands:

**Replace `YOUR_USERNAME` with your GitHub username:**

```powershell
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/mlops-product-classification.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## Complete Command Sequence

Copy and paste these commands (replace YOUR_USERNAME and your email):

```powershell
# 1. Configure Git (if not done already)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 2. Commit files
git commit -m "Initial commit: MLOps Product Classification Project"

# 3. Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/mlops-product-classification.git

# 4. Push to GitHub
git branch -M main
git push -u origin main
```

---

## Authentication

When you push, GitHub will ask for credentials:

**Option 1: Personal Access Token (Recommended)**
1. Go to: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` permission
3. Copy the token
4. When prompted for password, paste the token

**Option 2: GitHub CLI**
```powershell
gh auth login
git push -u origin main
```

---

## Verify Success

After pushing:
1. Go to: `https://github.com/YOUR_USERNAME/mlops-product-classification`
2. You should see all your files
3. Check that README.md is visible
4. Check that `.github/workflows/` exists

---

## What Gets Pushed

✅ **Pushed:**
- Source code
- Documentation
- Configuration files
- CI/CD workflows
- Scripts

❌ **NOT Pushed** (ignored):
- `venv/` folder
- `mlruns/` folder
- `models/*.txt` files
- `data/raw/*.csv` files
- `.env` files

---

**Ready?** Follow the steps above! 🚀


