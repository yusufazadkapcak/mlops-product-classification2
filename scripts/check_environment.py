"""Check if all required packages are installed."""
import sys

def check_package(package_name, import_name=None):
    """Check if a package is installed."""
    if import_name is None:
        import_name = package_name
    
    try:
        module = __import__(import_name)
        version = getattr(module, '__version__', 'unknown')
        print(f"✅ {package_name}: {version}")
        return True
    except ImportError:
        print(f"❌ {package_name}: NOT INSTALLED")
        return False

def main():
    """Check all required packages."""
    print("Checking required packages...")
    print("=" * 50)
    
    packages = [
        ("pandas", "pandas"),
        ("numpy", "numpy"),
        ("scikit-learn", "sklearn"),
        ("lightgbm", "lightgbm"),
        ("mlflow", "mlflow"),
        ("prefect", "prefect"),
        ("fastapi", "fastapi"),
        ("uvicorn", "uvicorn"),
        ("pydantic", "pydantic"),
        ("pytest", "pytest"),
        ("pyyaml", "yaml"),
        ("joblib", "joblib"),
    ]
    
    results = []
    for package_name, import_name in packages:
        results.append(check_package(package_name, import_name))
    
    print("=" * 50)
    
    if all(results):
        print("\n✅ All packages are installed!")
        print(f"\nPython: {sys.version}")
        print(f"Python executable: {sys.executable}")
        return 0
    else:
        print("\n❌ Some packages are missing!")
        print("Run: pip install -r requirements.txt")
        return 1

if __name__ == "__main__":
    sys.exit(main())



