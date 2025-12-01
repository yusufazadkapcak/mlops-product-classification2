"""Extract the latest model from MLflow and save it locally for API use."""
from pathlib import Path
import sys
import os

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))
os.environ['PYTHONPATH'] = str(project_root)

# Change to project directory
os.chdir(project_root)

def extract_latest_model():
    """Extract the latest model from MLflow runs."""
    # Import mlflow inside function to avoid conflicts
    import mlflow  # type: ignore
    
    # Set tracking URI to file-based
    mlflow.set_tracking_uri("file:./mlruns")
    
    # Get the latest run
    experiment = mlflow.get_experiment_by_name("product_classification")
    if experiment is None:
        print("No experiment found. Please train a model first.")
        return
    
    runs = mlflow.search_runs(experiment_ids=[experiment.experiment_id], order_by=["start_time desc"], max_results=1)
    
    if runs.empty:
        print("No runs found. Please train a model first.")
        return
    
    latest_run = runs.iloc[0]
    run_id = latest_run['run_id']
    
    print(f"Found latest run: {run_id}")
    print(f"Model URI: runs:/{run_id}/model")
    
    # Create models directory
    model_dir = Path("models")
    model_dir.mkdir(exist_ok=True)
    
    try:
        # Try to load model using mlflow.lightgbm
        try:
            import mlflow.lightgbm  # type: ignore
            model = mlflow.lightgbm.load_model(f"runs:/{run_id}/model")
            model_path = model_dir / "model.txt"
            model.save_model(str(model_path))
            print(f"✓ Model saved to: {model_path}")
        except Exception as e:
            print(f"Could not load with mlflow.lightgbm: {e}")
            print("Trying alternative method...")
            
            # Alternative: copy from artifacts
            artifact_path = Path(f"mlruns/{experiment.experiment_id}/{run_id}/artifacts/model")
            if artifact_path.exists():
                # Look for model files
                model_files = list(artifact_path.glob("*.txt")) + list(artifact_path.glob("*.lgb"))
                if model_files:
                    import shutil
                    shutil.copy(model_files[0], model_dir / "model.txt")
                    print(f"✓ Model copied to: {model_dir / 'model.txt'}")
                else:
                    print(f"Model files not found in {artifact_path}")
            else:
                print(f"Artifact path not found: {artifact_path}")
    except Exception as e:
        print(f"Error extracting model: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    extract_latest_model()
