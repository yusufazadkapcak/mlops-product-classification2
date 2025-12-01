"""Script to verify MLflow setup is working correctly."""
import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

def check_mlflow_installation():
    """Check if MLflow is installed."""
    print("=" * 60)
    print("Step 1: Checking MLflow Installation")
    print("=" * 60)
    try:
        import mlflow
        print(f"✅ MLflow is installed (version: {mlflow.__version__})")
        return True
    except ImportError:
        print("❌ MLflow is NOT installed")
        print("   Install it with: pip install mlflow")
        return False


def check_tracking_uri():
    """Check if we can connect to tracking URI."""
    print("\n" + "=" * 60)
    print("Step 2: Checking Tracking URI")
    print("=" * 60)
    try:
        import mlflow
        
        # Try file-based tracking first
        tracking_uri = "file:./mlruns"
        mlflow.set_tracking_uri(tracking_uri)
        print(f"✅ Tracking URI set to: {tracking_uri}")
        
        # Try to get current tracking URI
        current_uri = mlflow.get_tracking_uri()
        print(f"✅ Current tracking URI: {current_uri}")
        
        return True
    except Exception as e:
        print(f"❌ Error setting tracking URI: {e}")
        return False


def create_test_experiment():
    """Create a test experiment and log some data."""
    print("\n" + "=" * 60)
    print("Step 3: Creating Test Experiment")
    print("=" * 60)
    try:
        import mlflow
        from src.tracking_utils.tracking import setup_mlflow
        
        # Setup MLflow
        setup_mlflow("file:./mlruns", "mlflow_verification_test")
        print("✅ MLflow setup complete")
        
        # Create a test run
        with mlflow.start_run(run_name="verification_test_run") as run:
            print(f"✅ Created test run: {run.info.run_id}")
            
            # Log some test parameters
            mlflow.log_param("test_param_1", "test_value_1")
            mlflow.log_param("test_param_2", 42)
            print("✅ Logged test parameters")
            
            # Log some test metrics
            mlflow.log_metric("test_accuracy", 0.95)
            mlflow.log_metric("test_f1", 0.92)
            print("✅ Logged test metrics")
            
            # Log a test artifact (text file)
            test_file = project_root / "mlruns" / "test_artifact.txt"
            test_file.parent.mkdir(parents=True, exist_ok=True)
            test_file.write_text("This is a test artifact for MLflow verification")
            mlflow.log_artifact(str(test_file), artifact_path="test")
            print("✅ Logged test artifact")
            
            print(f"\n✅ Test run completed successfully!")
            print(f"   Run ID: {run.info.run_id}")
            print(f"   Experiment: mlflow_verification_test")
            print(f"\n💡 Next steps:")
            print(f"   1. Start MLflow UI: python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5000 --workers 1")
            print(f"   2. Open browser: http://127.0.0.1:5000")
            print(f"   3. Look for experiment: 'mlflow_verification_test'")
            print(f"   4. Click on the run to see metrics, parameters, and artifacts")
        
        return True
    except Exception as e:
        print(f"❌ Error creating test experiment: {e}")
        import traceback
        traceback.print_exc()
        return False


def check_mlruns_directory():
    """Check if mlruns directory exists and has content."""
    print("\n" + "=" * 60)
    print("Step 4: Checking MLruns Directory")
    print("=" * 60)
    mlruns_dir = project_root / "mlruns"
    
    if not mlruns_dir.exists():
        print("⚠️  mlruns directory doesn't exist (will be created on first run)")
        mlruns_dir.mkdir(parents=True, exist_ok=True)
        print("✅ Created mlruns directory")
    else:
        print(f"✅ mlruns directory exists: {mlruns_dir}")
        
        # Count experiments
        experiment_dirs = [d for d in mlruns_dir.iterdir() if d.is_dir() and d.name != "0"]
        if experiment_dirs:
            print(f"✅ Found {len(experiment_dirs)} experiment(s)")
        else:
            print("ℹ️  No experiments yet (this is normal for first run)")


def main():
    """Run all verification steps."""
    print("\n" + "=" * 60)
    print("MLflow Verification Script")
    print("=" * 60)
    print("\nThis script will verify that MLflow is set up correctly.")
    print("Make sure your virtual environment is activated!\n")
    
    results = []
    
    # Step 1: Check installation
    results.append(("MLflow Installation", check_mlflow_installation()))
    
    if not results[0][1]:
        print("\n❌ MLflow is not installed. Please install it first.")
        return False
    
    # Step 2: Check tracking URI
    results.append(("Tracking URI", check_tracking_uri()))
    
    # Step 3: Check mlruns directory
    check_mlruns_directory()
    
    # Step 4: Create test experiment
    results.append(("Test Experiment", create_test_experiment()))
    
    # Summary
    print("\n" + "=" * 60)
    print("Verification Summary")
    print("=" * 60)
    
    all_passed = True
    for name, passed in results:
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status}: {name}")
        if not passed:
            all_passed = False
    
    print("\n" + "=" * 60)
    if all_passed:
        print("🎉 All checks passed! MLflow is working correctly.")
        print("\nTo view your experiments:")
        print("1. Start MLflow UI in a terminal:")
        print("   python -m mlflow ui --backend-store-uri file:./mlruns --host 127.0.0.1 --port 5000 --workers 1")
        print("2. Open browser: http://127.0.0.1:5000")
    else:
        print("⚠️  Some checks failed. Please review the errors above.")
    print("=" * 60 + "\n")
    
    return all_passed


if __name__ == "__main__":
    try:
        success = main()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\nVerification interrupted by user.")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

