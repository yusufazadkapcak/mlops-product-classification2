"""Script to generate sample data for testing."""
import sys
import os
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

# Set PYTHONPATH environment variable
os.environ['PYTHONPATH'] = str(project_root)

from src.data.load import generate_sample_data
import pandas as pd


def main():
    """Generate sample data and save to data/raw/"""
    print("Generating sample product data...")
    
    # Generate 10,000 samples
    data = generate_sample_data(n_samples=10000)
    
    # Save to data/raw/
    output_path = Path(__file__).parent.parent / "data" / "raw" / "products.csv"
    
    # Create directory (handle Windows path issues gracefully)
    output_dir = str(output_path.parent)
    
    # Check if it's already a directory - if so, we're done
    if os.path.isdir(output_dir):
        pass  # Directory exists, proceed
    else:
        # If it exists but is not a directory (might be a file), remove it
        if os.path.exists(output_dir):
            try:
                if os.path.isfile(output_dir):
                    os.remove(output_dir)
            except Exception:
                pass
        
        # Create the directory
        try:
            os.makedirs(output_dir, exist_ok=True)
        except (FileExistsError, OSError) as e:
            # If it still fails, check if it's now a directory
            if not os.path.isdir(output_dir):
                print(f"Warning: Could not create directory {output_dir}: {e}")
                print("Please manually create the directory or remove any file at that path.")
                raise
    
    # Convert path to string for pandas (more reliable on Windows)
    data.to_csv(str(output_path), index=False)
    
    print(f"Generated {len(data)} samples")
    print(f"Saved to: {output_path}")
    print(f"\nData preview:")
    print(data.head())
    print(f"\nData info:")
    print(data.info())
    print(f"\nCategory distribution:")
    print(data["category"].value_counts())


if __name__ == "__main__":
    main()

