"""Unit tests for data loading and preprocessing."""

import unittest
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from src.data.load import load_data, generate_sample_data
from src.data.preprocess import preprocess_data, split_data
import pandas as pd


class TestData(unittest.TestCase):
    """Test cases for data loading and preprocessing."""

    def test_generate_sample_data(self):
        """Test sample data generation."""
        data = generate_sample_data(n_samples=100)
        self.assertIsNotNone(data)
        self.assertEqual(len(data), 100)
        self.assertIn("title", data.columns)
        self.assertIn("seller_id", data.columns)
        self.assertIn("brand", data.columns)
        self.assertIn("category", data.columns)

    def test_load_data_with_generation(self):
        """Test data loading with automatic generation."""
        data = load_data()
        self.assertIsNotNone(data)
        self.assertGreater(len(data), 0)
        self.assertIn("title", data.columns)

    def test_preprocess_data(self):
        """Test data preprocessing."""
        raw_data = generate_sample_data(n_samples=100)
        processed_data = preprocess_data(raw_data)
        self.assertIsNotNone(processed_data)
        self.assertGreater(len(processed_data), 0)
        # Check that missing values are handled
        self.assertFalse(processed_data["title"].isna().any())

    def test_split_data(self):
        """Test data splitting."""
        raw_data = generate_sample_data(n_samples=1000)
        processed_data = preprocess_data(raw_data)
        X_train, X_test, y_train, y_test = split_data(
            processed_data, test_size=0.2, random_seed=42
        )
        self.assertGreater(len(X_train), 0)
        self.assertGreater(len(X_test), 0)
        self.assertEqual(len(X_train), len(y_train))
        self.assertEqual(len(X_test), len(y_test))


if __name__ == "__main__":
    unittest.main()
