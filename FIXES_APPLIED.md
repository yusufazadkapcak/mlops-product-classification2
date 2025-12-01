# Fixes Applied

## Issue: MLflow Module Shadowing

**Problem:** The local `src/mlflow` folder was shadowing the installed `mlflow` package, causing `AttributeError: module 'mlflow' has no attribute 'set_tracking_uri'`.

**Solution:** Renamed `src/mlflow` to `src/tracking_utils` to avoid the naming conflict.

## Changes Made:

1. Created `src/tracking_utils/` folder with:
   - `__init__.py` - exports all tracking functions
   - `tracking.py` - MLflow tracking utilities (properly imports actual mlflow package)

2. Updated imports in:
   - `src/workflows/prefect_pipeline.py` - changed from `src.mlflow.tracking` to `src.tracking_utils.tracking`
   - `src/models/train.py` - cleaned up mlflow imports

3. Fixed Prefect flow decorator:
   - Added `validate_parameters=False` to avoid Pydantic validation issues

## To Use:

All imports now use `src.tracking_utils` instead of `src.mlflow`. The code should work correctly now.


