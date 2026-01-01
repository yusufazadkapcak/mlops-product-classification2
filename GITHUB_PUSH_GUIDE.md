# GitHub Push Guide

## Step-by-Step Instructions

### Step 1: Create GitHub Repository

1. Go to https://github.com
2. Click the **"+"** icon → **"New repository"**
3. Repository name: `mlops-product-classification` (or your preferred name)
4. Description: "MLOps Product Classification Project - End-to-end ML pipeline"
5. Choose: **Public** or **Private**
6. **DO NOT** initialize with README, .gitignore, or license (we already have these)
7. Click **"Create repository"**

### Step 2: Add Remote and Push

After creating the repository, GitHub will show you commands. Use these:

```powershell
# Add remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/mlops-product-classification.git

# Verify remote was added
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

### Alternative: Using SSH (if you have SSH keys set up)

```powershell
git remote add origin git@github.com:YOUR_USERNAME/mlops-product-classification.git
git branch -M main
git push -u origin main
```

---

## Quick Commands (Copy-Paste Ready)

**Replace `YOUR_USERNAME` with your GitHub username:**

```powershell
# 1. Add remote
git remote add origin https://github.com/YOUR_USERNAME/mlops-product-classification.git

# 2. Rename branch to main (if needed)
git branch -M main

# 3. Push to GitHub
git push -u origin main
```

---

## If You Get Authentication Error

If you see authentication errors, you may need to:

1. **Use Personal Access Token:**
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token with `repo` permissions
   - Use token as password when pushing

2. **Or use GitHub CLI:**
   ```powershell
   gh auth login
   git push -u origin main
   ```

---

## Verify Push Was Successful

1. Go to your GitHub repository page
2. You should see all your files
3. Check that `.github/workflows/` folder exists (for CI/CD)
4. Check that `README.md` is visible

---

## Future Updates

After making changes:

```powershell
# Stage changes
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push
```

---

## What Gets Pushed

✅ **Will be pushed:**
- All source code (`src/`)
- Configuration files (`configs/`, `docker/`)
- Documentation (`.md` files)
- CI/CD workflows (`.github/workflows/`)
- Scripts (`scripts/`)
- Tests (`tests/`)

❌ **Will NOT be pushed** (thanks to `.gitignore`):
- `venv/` (virtual environment)
- `mlruns/` (MLflow tracking data)
- `models/*.txt`, `models/*.joblib` (trained models)
- `data/raw/*.csv` (data files)
- `.env` files (environment variables)
- `__pycache__/` (Python cache)

---

## Troubleshooting

### Error: "remote origin already exists"
```powershell
# Remove existing remote
git remote remove origin

# Add again
git remote add origin https://github.com/YOUR_USERNAME/mlops-product-classification.git
```

### Error: "failed to push some refs"
```powershell
# Pull first (if repository has initial commit)
git pull origin main --allow-unrelated-histories

# Then push
git push -u origin main
```

### Error: Authentication failed
- Use Personal Access Token instead of password
- Or set up SSH keys

---

**Ready to push?** Follow Step 2 above! 🚀


