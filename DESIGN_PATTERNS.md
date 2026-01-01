# Design Patterns Implementation

This document describes the mandatory design patterns implemented in the working demo.

## 1. Reframing & Rebalancing (Training)

**Location**: `src/data/rebalancing.py`, integrated into `src/models/train.py`

**Purpose**: Handle class imbalance in training data

### Reframing
- **What**: Combines minority classes (classes with < 5% of samples) into an "Other" category
- **Why**: Reduces the number of classes and helps with rare class prediction
- **When**: Applied automatically if class imbalance is detected

### Rebalancing
- **Methods Available**:
  - `class_weight`: Applies class weights during training (default, no data modification)
  - `oversample`: Oversamples minority classes to match majority class
  - `undersample`: Undersamples majority classes to match minority class
  - `SMOTE`: Uses Synthetic Minority Oversampling Technique (requires `imbalanced-learn`)

**Usage in Training**:
```python
from src.models.train import train_model

model, metrics = train_model(
    X_train, y_train,
    enable_reframing=True,
    enable_rebalancing=True,
    rebalancing_method="class_weight"
)
```

**MLflow Logging**:
- Logs imbalance ratio
- Logs reframing/rebalancing parameters
- Tracks class distribution before/after

## 2. Checkpoints (Resilience)

**Location**: `src/models/checkpoints.py`, integrated into `src/models/train.py`

**Purpose**: Save model state during training to enable recovery from failures

### Features
- **Automatic Checkpointing**: Saves model every N iterations (default: 10)
- **Best Model Tracking**: Keeps track of best model based on validation metric
- **Metadata Storage**: Saves metrics, iteration number, label mappings
- **Checkpoint Management**: Automatically cleans old checkpoints (keeps best + recent)

**Usage**:
```python
from src.models.checkpoints import ModelCheckpoint

checkpoint_manager = ModelCheckpoint(
    checkpoint_dir="models/checkpoints",
    save_freq=10,
    keep_best=True,
    max_checkpoints=5
)

# Checkpoint is automatically saved during training
# To load a checkpoint:
model, metadata = checkpoint_manager.load_checkpoint(load_best=True)
```

**Checkpoint Structure**:
```
models/checkpoints/
├── checkpoint_best.txt          # Best model
├── checkpoint_best_metadata.joblib
├── checkpoint_iter_10.txt        # Iteration 10
├── checkpoint_iter_10_metadata.joblib
└── ...
```

## 3. Drift Detection & Algorithmic Fallback (Serving)

**Location**: `src/inference/drift_detection.py`, integrated into `src/inference/api.py`

**Purpose**: Detect data/concept drift and fallback to simpler algorithm when needed

### Drift Detection

#### Data Drift
- **Method**: Compares incoming data distribution to reference (training) data
- **Metric**: Kolmogorov-Smirnov-like statistic comparing means and standard deviations
- **Threshold**: Default 0.1 (configurable)
- **Window**: Sliding window of last N requests (default: 100)

#### Concept Drift
- **Method**: Monitors prediction confidence
- **Trigger**: Average confidence < threshold OR >30% of predictions have low confidence
- **Threshold**: Default 0.5 (configurable)

### Algorithmic Fallback

**Fallback Models**:
1. **Random Forest** (default): Trained on same training data, simpler than LightGBM
2. **Naive Bayes**: Very fast, good baseline
3. **Rule-based**: Simple heuristics based on features

**Fallback Triggers**:
- Data drift detected
- Concept drift detected (low confidence)
- Main model fails/throws error

**Usage in API**:
```python
# Automatically enabled in FastAPI inference
# Fallback model is trained during API startup if training data available
```

**API Response**:
- Normal prediction: Uses main LightGBM model
- Fallback prediction: Uses simpler model, logs warning
- Both include confidence scores

## Integration Points

### Training Pipeline (`src/main.py`)
All patterns are enabled by default:
```python
train_model(
    X_train, y_train,
    enable_reframing=True,
    enable_rebalancing=True,
    enable_checkpoints=True
)
```

### Serving API (`src/inference/api.py`)
Drift detection and fallback are automatically enabled:
- Loads reference data on startup
- Initializes drift detector
- Trains/loads fallback model
- Monitors each prediction request

## MLflow Tracking

All design patterns log to MLflow:
- **Reframing**: Logs imbalance ratio, reframing status
- **Rebalancing**: Logs method used, class distribution
- **Checkpoints**: Logs checkpoint save events
- **Drift Detection**: Logs drift events (can be extended)

## Testing

To test design patterns:

1. **Reframing & Rebalancing**:
   ```bash
   python src/main.py
   # Check MLflow UI for imbalance metrics
   ```

2. **Checkpoints**:
   ```bash
   python src/main.py
   # Check models/checkpoints/ directory
   # Try loading: python -c "from src.models.checkpoints import ModelCheckpoint; m = ModelCheckpoint(); model, meta = m.load_checkpoint(load_best=True)"
   ```

3. **Drift Detection & Fallback**:
   ```bash
   # Start API
   python src/inference/api.py
   
   # Send requests with unusual data (different distribution)
   curl -X POST http://localhost:8000/predict \
     -H "Content-Type: application/json" \
     -d '{"title": "test", "price": 99999}'
   # Check logs for drift detection warnings
   ```

## Configuration

Design patterns can be configured via:
- Training function parameters
- Environment variables (can be extended)
- Configuration files (can be extended)

## Future Enhancements

- [ ] More sophisticated drift detection (PSI, KS test)
- [ ] Online learning for fallback model
- [ ] Alerting system for drift events
- [ ] A/B testing framework for fallback models
- [ ] Automatic retraining triggers based on drift







