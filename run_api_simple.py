"""Simple FastAPI server launcher - direct import method."""
import sys
import os
from pathlib import Path

# Get project root
project_root = Path(__file__).parent.absolute()
sys.path.insert(0, str(project_root))
os.environ['PYTHONPATH'] = str(project_root)
os.chdir(project_root)

# Import and run directly
if __name__ == "__main__":
    print(f"Project root: {project_root}")
    print("Starting FastAPI server...")
    print("Server will be at: http://127.0.0.1:8000")
    print("API docs: http://127.0.0.1:8000/docs")
    print("\nPress Ctrl+C to stop\n")
    
    try:
        # Import the app directly
        from src.inference.api import app
        
        # Use uvicorn programmatically
        import uvicorn
        uvicorn.run(
            app,  # Pass app object directly, not string
            host="127.0.0.1",
            port=8000,
            log_level="info"
        )
    except Exception as e:
        print(f"Error starting server: {e}")
        import traceback
        traceback.print_exc()
        input("Press Enter to exit...")


