"""Unit tests for model training."""
import unittest
import sys
from pathlib import Path
import pandas as pd
import numpy as np

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from src.data.load import generate_sample_data
from src.data.preprocess import preprocess_data, split_data
from src.features.build_features import build_features
from src.models.train import train_model
import lightgbm as lgb


class TestModels(unittest.TestCase):
    """Test cases for model training."""

    def setUp(self):
        """Set up test data."""
        # Generate small dataset for testing
        raw_data = generate_sample_data(n_samples=200)
        processed_data = preprocess_data(raw_data)
        features = build_features(processed_data)
        features["category"] = processed_data["category"]
        
        X_train, X_test, y_train, y_test = split_data(
            features, test_size=0.3, random_seed=42
        )
        
        self.X_train = X_train
        self.X_test = X_test
        self.y_train = y_train
        self.y_test = y_test

    def test_train_model(self):
        """Test model training."""
        # Further split for validation
        from sklearn.model_selection import train_test_split
        X_train_final, X_val, y_train_final, y_val = train_test_split(
            self.X_train, self.y_train, test_size=0.2, random_state=42
        )
        
        # Set up minimal MLflow (use file store)
        import mlflow
        mlflow.set_tracking_uri("file:./mlruns")
        
        model, metrics = train_model(
            X_train_final,
            y_train_final,
            X_val,
            y_val,
            mlflow_experiment_name="test_experiment"
        )
        
        self.assertIsNotNone(model)
        self.assertIn("train_accuracy", metrics)
        self.assertGreater(metrics["train_accuracy"], 0)


if __name__ == "__main__":
    unittest.main()
