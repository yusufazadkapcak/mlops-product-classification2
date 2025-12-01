"""Simple launcher for FastAPI server (Windows-compatible)."""
import uvicorn
import sys
import os
from pathlib import Path

# Get the directory where this script is located
script_dir = Path(__file__).parent.absolute()
project_root = script_dir

# Add project root to Python path
if str(project_root) not in sys.path:
    sys.path.insert(0, str(project_root))

# Set PYTHONPATH environment variable
os.environ['PYTHONPATH'] = str(project_root)

# Change to project directory
os.chdir(project_root)

if __name__ == "__main__":
    # Use 127.0.0.1 for Windows compatibility
    # Single worker to avoid Windows socket issues
    print(f"Project root: {project_root}")
    print(f"Python path: {sys.path[:3]}")
    print(f"Starting API server on http://127.0.0.1:8000")
    print(f"API docs: http://127.0.0.1:8000/docs")
    
    # Use single worker and disable reload to avoid Windows socket issues
    uvicorn.run(
        "src.inference.api:app",
        host="127.0.0.1",
        port=8000,
        log_level="info",
        workers=1,
        reload=False
    )

