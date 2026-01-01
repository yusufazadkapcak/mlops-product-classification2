"""Integration tests for the full pipeline."""

import shutil
import sys
import tempfile
import unittest
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))


from src.data.load import generate_sample_data
from src.data.preprocess import preprocess_data
from src.features.build_features import build_features
from src.models.train import evaluate_model, train_model


class TestPipeline(unittest.TestCase):
    """Integration tests for the full pipeline."""

    def setUp(self):
        """Set up test environment."""
        # Create temporary directory for MLflow
        self.temp_dir = tempfile.mkdtemp()
        import mlflow

        mlflow.set_tracking_uri(f"file:{self.temp_dir}/mlruns")

    def tearDown(self):
        """Clean up test environment."""
        shutil.rmtree(self.temp_dir, ignore_errors=True)

    def test_full_pipeline(self):
        """Test the full pipeline from data to model."""
        # Step 1: Generate data
        raw_data = generate_sample_data(n_samples=500)
        self.assertGreater(len(raw_data), 0)

        # Step 2: Preprocess
        processed_data = preprocess_data(raw_data)
        self.assertGreater(len(processed_data), 0)

        # Step 3: Build features
        features = build_features(processed_data)
        features["category"] = processed_data["category"]
        self.assertGreater(features.shape[1], 0)

        # Step 4: Split data
        from src.data.preprocess import split_data

        X_train, X_test, y_train, y_test = split_data(
            features, test_size=0.2, random_seed=42
        )

        # Step 5: Further split for validation
        from sklearn.model_selection import train_test_split

        X_train_final, X_val, y_train_final, y_val = train_test_split(
            X_train, y_train, test_size=0.2, random_state=42
        )

        # Step 6: Train model
        model, train_metrics = train_model(
            X_train_final,
            y_train_final,
            X_val,
            y_val,
            mlflow_experiment_name="integration_test",
        )
        self.assertIsNotNone(model)
        self.assertIn("train_accuracy", train_metrics)

        # Step 7: Evaluate model
        test_metrics = evaluate_model(model, X_test, y_test)
        self.assertIn("test_accuracy", test_metrics)
        self.assertGreater(test_metrics["test_accuracy"], 0)


if __name__ == "__main__":
    unittest.main()
