# Create GitHub Repository

## Step 1: Create Repository on GitHub

1. Go to **https://github.com/new**
2. Repository name: `mlops-product-classification`
3. Description: `MLOps Product Classification Pipeline with MLflow, Prefect, and FastAPI`
4. Choose: **Public** or **Private** (your choice)
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. Click **"Create repository"**

## Step 2: Push Your Code

After creating the repository, run:

```powershell
git push origin main
```

If you get authentication errors, you may need to:
- Use a Personal Access Token instead of password
- Or use SSH instead of HTTPS

## Alternative: Use GitHub CLI (if installed)

```powershell
gh repo create mlops-product-classification --public --source=. --remote=origin --push
```

