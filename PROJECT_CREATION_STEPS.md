# 🛠️ Project Creation Steps - Simple Guide

## How We Built This Project (Step-by-Step)

---

## Phase 1: Planning & Setup (Week 1)

### Step 1: Define the Problem
**What we did:**
- Decided to build a product categorization system
- Identified the goal: Automatically categorize products

**Why:**
- E-commerce sites need to organize products
- Manual categorization is time-consuming
- ML can automate this process

---

### Step 2: Set Up Development Environment
**What we did:**
```powershell
# 1. Create project folder
mkdir mlops-product-classification
cd mlops-product-classification

# 2. Create virtual environment
python -m venv venv
.\venv\Scripts\Activate.ps1

# 3. Install dependencies
pip install -r requirements.txt
```

**Why:**
- Isolated environment prevents conflicts
- Easy to share with team
- Reproducible setup

---

### Step 3: Create Project Structure
**What we did:**
```
mlops-product-classification/
├── src/
│   ├── data/          # Data loading & cleaning
│   ├── features/      # Feature engineering
│   ├── models/        # Model training
│   ├── inference/     # API serving
│   └── workflows/     # Pipeline automation
├── tests/             # Testing
├── docker/            # Containerization
└── configs/           # Configuration files
```

**Why:**
- Organized code is easier to maintain
- Clear separation of concerns
- Team can work on different parts

---

## Phase 2: Data Pipeline (Week 2)

### Step 4: Data Loading
**What we did:**
- Created `src/data/load.py`
- Added function to load CSV files
- Added auto-generation of sample data (10,000 products)

**Code example:**
```python
def load_data():
    # Try to load from file
    # If not found, generate sample data
    return data
```

**Why:**
- Need data to train the model
- Sample data helps testing
- Flexible (works with or without real data)

---

### Step 5: Data Preprocessing
**What we did:**
- Created `src/data/preprocess.py`
- Clean missing values
- Normalize text (product titles)
- Split data: 80% train, 20% test

**Why:**
- Clean data = better model
- Need separate test set to evaluate
- Preprocessing is crucial for ML

---

## Phase 3: Feature Engineering (Week 2-3)

### Step 6: Handle High-Cardinality Features
**What we did:**
- Created `src/features/build_features.py`
- Implemented hash encoding for seller_id (5000+ values)
- Implemented hash encoding for brand and subcategory

**Why:**
- Too many unique values for one-hot encoding
- Hash encoding reduces memory usage
- Fixed-size features work better with ML models

**Example:**
```python
# Instead of 5000 columns for sellers
# We use hash encoding → 1000 buckets
seller_id_hashed = hash(seller_id) % 1000
```

---

### Step 7: Create Feature Crosses
**What we did:**
- Combined brand × price_range
- Created: "Nike_high_price", "Samsung_mid_price", etc.
- Hashed the combinations

**Why:**
- Models learn relationships better
- "Nike + High Price" often = Clothing
- Feature crosses capture interactions

---

### Step 8: Extract Text Features
**What we did:**
- Title length
- Word count
- Keyword detection (premium, pro, sale, etc.)

**Why:**
- Text contains valuable information
- Simple features are effective
- Easy to extract and use

---

## Phase 4: Model Training (Week 3-4)

### Step 9: Choose ML Algorithm
**What we did:**
- Selected LightGBM (gradient boosting)
- Good for tabular data
- Fast training and prediction

**Why:**
- Handles mixed data types well
- Fast and accurate
- Industry standard

---

### Step 10: Train the Model
**What we did:**
- Created `src/models/train.py`
- Split data: train (64%), validation (16%), test (20%)
- Train with LightGBM
- Evaluate on test set

**Process:**
```
1. Load data
2. Build features
3. Split into train/val/test
4. Train model
5. Evaluate on test set
6. Save model
```

**Why:**
- Need to train before using
- Validation helps tune hyperparameters
- Test set shows real performance

---

### Step 11: Set Up MLflow Tracking
**What we did:**
- Created `src/tracking_utils/tracking.py`
- Log all parameters (learning rate, num_leaves, etc.)
- Log all metrics (accuracy, F1, precision, recall)
- Save model artifacts

**Why:**
- Track what works and what doesn't
- Compare different experiments
- Reproduce good results

---

## Phase 5: Model Serving (Week 4-5)

### Step 12: Build FastAPI
**What we did:**
- Created `src/inference/api.py`
- Endpoints:
  - `/health` - Check if API is working
  - `/predict` - Single prediction
  - `/predict/batch` - Multiple predictions

**Why:**
- Need a way to use the model
- REST API is standard
- FastAPI is fast and easy

---

### Step 13: Load Model in API
**What we did:**
- Load model on startup
- Load label mappings
- Handle errors gracefully

**Why:**
- Model needs to be loaded before use
- Fast startup = better user experience
- Error handling prevents crashes

---

## Phase 6: Automation (Week 5)

### Step 14: Set Up Prefect Pipeline
**What we did:**
- Created `src/workflows/prefect_pipeline.py`
- Automated: data → features → train → evaluate → register

**Why:**
- Manual steps are error-prone
- Automation saves time
- Reproducible pipeline

---

### Step 15: Set Up CI/CD
**What we did:**
- Created `.github/workflows/ci.yml` - Automated testing
- Created `.github/workflows/train.yml` - Automated training
- Created `.github/workflows/deploy.yml` - Automated deployment

**Why:**
- Catch bugs early
- Automate repetitive tasks
- Ensure code quality

---

## Phase 7: Containerization (Week 5-6)

### Step 16: Create Dockerfiles
**What we did:**
- `docker/Dockerfile` - For training
- `docker/Dockerfile.inference` - For API
- `docker/docker-compose.yml` - Full stack

**Why:**
- Works the same everywhere
- Easy to deploy
- Isolated environment

---

## Phase 8: Cloud Deployment (Week 6)

### Step 17: Set Up AWS Deployment
**What we did:**
- Created `aws/` folder with deployment scripts
- ECS task definitions
- S3 for artifacts
- CloudWatch for logs

**Why:**
- Production needs cloud deployment
- Scalable and reliable
- Professional setup

---

## Phase 9: Testing (Week 6-7)

### Step 18: Write Tests
**What we did:**
- Unit tests (`tests/unit/`)
- Integration tests (`tests/integration/`)
- API tests

**Why:**
- Ensure code works correctly
- Catch bugs before production
- Confidence in changes

---

## Phase 10: Documentation (Week 7-8)

### Step 19: Write Documentation
**What we did:**
- README.md - Project overview
- Setup guides
- API documentation
- Deployment guides

**Why:**
- Others need to understand the project
- Future you will thank you
- Professional presentation

---

## Phase 11: Presentation (Week 8)

### Step 20: Prepare Demo
**What we did:**
- Practice running the pipeline
- Prepare MLflow UI demo
- Test API endpoints
- Create presentation slides

**Why:**
- Need to show it works
- Demonstrate value
- Impress stakeholders

---

## 📊 Timeline Summary

| Week | Phase | Key Activities |
|------|-------|----------------|
| 1 | Setup | Environment, project structure |
| 2 | Data | Data loading, preprocessing |
| 3 | Features | Feature engineering |
| 4 | Model | Training, MLflow setup |
| 5 | API | FastAPI, Prefect pipeline |
| 6 | DevOps | Docker, CI/CD, AWS |
| 7 | Testing | Unit tests, integration tests |
| 8 | Docs & Demo | Documentation, presentation |

---

## 🎯 Key Decisions Made

### Why Hash Encoding?
- **Problem:** 5000+ sellers, too many for one-hot
- **Solution:** Hash encoding (1000 buckets)
- **Result:** Fixed memory, good performance

### Why LightGBM?
- **Reason:** Fast, accurate, handles mixed data
- **Alternative considered:** XGBoost, Random Forest
- **Decision:** LightGBM is faster with similar accuracy

### Why Prefect?
- **Reason:** Dynamic workflows, Python-native
- **Alternative considered:** Airflow, Kubeflow
- **Decision:** Prefect is easier for Python teams

### Why FastAPI?
- **Reason:** Fast, modern, auto-documentation
- **Alternative considered:** Flask, Django
- **Decision:** FastAPI is faster and has better docs

---

## 💡 Lessons Learned

1. **Start Simple:** Begin with basic pipeline, then add complexity
2. **Test Early:** Write tests as you code
3. **Document As You Go:** Don't wait until the end
4. **Use Version Control:** Git from day one
5. **Track Experiments:** MLflow from the start

---

## 🚀 Quick Start (For New Team Members)

```powershell
# 1. Clone repository
git clone https://github.com/your-repo/mlops-product-classification.git
cd mlops-product-classification

# 2. Setup environment
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt

# 3. Generate data
python scripts/generate_sample_data.py

# 4. Train model
python src/main.py

# 5. Start API
python -m uvicorn src.inference.api:app

# 6. Start MLflow
python -m mlflow ui --host 127.0.0.1 --port 5000
```

---

## ✅ Success Checklist

- [ ] Data pipeline working
- [ ] Features engineered (19 features)
- [ ] Model trained (>80% accuracy)
- [ ] MLflow tracking working
- [ ] API serving predictions
- [ ] Prefect pipeline automated
- [ ] Docker containers working
- [ ] CI/CD pipeline running
- [ ] AWS deployment ready
- [ ] Tests passing
- [ ] Documentation complete

---

**That's how we built it!** 🎉








