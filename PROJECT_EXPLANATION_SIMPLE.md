# 📦 Product Classification Project - Simple Explanation

## What Does This Project Do?

**Simple Answer:** We built a system that automatically categorizes products (like "Electronics", "Clothing", "Home & Garden") based on product information.

**Example:**
- Input: "Nike Pro Running Shoes, $129.99, Brand: Nike, Rating: 4.5"
- Output: "Clothing" (with 87% confidence)

---

## The Big Picture: How It Works

Think of it like a factory assembly line:

```
📥 Raw Data → 🧹 Clean Data → 🔧 Build Features → 🤖 Train Model → 📊 Track Experiments → 🚀 Deploy API
```

### Step-by-Step Flow:

1. **Get Product Data** 📥
   - We have product information: title, price, brand, seller, rating, etc.
   - Example: 10,000 products from an e-commerce site

2. **Clean the Data** 🧹
   - Remove missing values
   - Fix text formatting
   - Split into training/testing sets

3. **Build Features** 🔧
   - Convert product info into numbers the computer can understand
   - Special handling for things like seller IDs (we have 5000+ different sellers!)
   - Create smart combinations (like "Nike + High Price Range")

4. **Train the Model** 🤖
   - Teach the computer to recognize patterns
   - "When I see Nike + $100-200 price → it's usually Clothing"
   - Uses LightGBM (a powerful machine learning algorithm)

5. **Track Everything** 📊
   - MLflow records every experiment
   - We can see which model version works best
   - Like a lab notebook for machine learning

6. **Deploy as API** 🚀
   - Put the model online so anyone can use it
   - Send product info → Get category prediction
   - Works 24/7, handles multiple requests

---

## Key Components (What We Built)

### 1. **Data Pipeline** (`src/data/`)
- **What it does:** Loads and cleans product data
- **Why it matters:** Good data = good predictions

### 2. **Feature Engineering** (`src/features/`)
- **What it does:** Converts product info into 19 numerical features
- **Special trick:** Hash encoding for high-cardinality features (5000+ sellers!)
- **Why it matters:** Makes the data understandable for the model

### 3. **Model Training** (`src/models/`)
- **What it does:** Trains a LightGBM classifier
- **Why it matters:** This is the "brain" that makes predictions

### 4. **MLflow Tracking** (`src/tracking_utils/`)
- **What it does:** Records every experiment, tracks model versions
- **Why it matters:** We can compare models and pick the best one

### 5. **Prefect Orchestration** (`src/workflows/`)
- **What it does:** Automates the entire pipeline
- **Why it matters:** One command runs everything automatically

### 6. **FastAPI** (`src/inference/`)
- **What it does:** Web API for predictions
- **Why it matters:** Anyone can use our model via HTTP requests

### 7. **Docker** (`docker/`)
- **What it does:** Packages everything in containers
- **Why it matters:** Works the same everywhere (your laptop, AWS, anywhere)

### 8. **CI/CD** (`.github/workflows/`)
- **What it does:** Automatically tests and deploys when code changes
- **Why it matters:** Ensures quality and automates deployment

---

## What Makes This Special? (MLOps Features)

### ✅ **High-Cardinality Feature Handling**
- **Problem:** We have 5000+ different sellers, 40+ brands
- **Solution:** Hash encoding (converts them to fixed-size numbers)
- **Why it matters:** Without this, the model would struggle with so many categories

### ✅ **Feature Crosses**
- **What:** Combines brand × price_range (e.g., "Nike + $100-200")
- **Why:** Helps the model learn that "Nike + High Price = Clothing"

### ✅ **Experiment Tracking**
- **What:** MLflow tracks every model version, metrics, parameters
- **Why:** We can see which model works best and why

### ✅ **Model Registry**
- **What:** Version control for models (like Git for code)
- **Why:** We can promote good models to "Production" stage

### ✅ **Automated Pipeline**
- **What:** Prefect runs everything automatically
- **Why:** No manual steps, reduces errors

### ✅ **Production API**
- **What:** FastAPI serves predictions 24/7
- **Why:** Real-world applications can use our model

### ✅ **Cloud Ready**
- **What:** Can deploy to AWS (or any cloud)
- **Why:** Scalable, reliable, accessible from anywhere

---

## Real-World Example

**Scenario:** An e-commerce site wants to auto-categorize new products

1. **New product arrives:** "Samsung Galaxy S24, $999, Brand: Samsung"
2. **Send to our API:**
   ```json
   {
     "title": "Samsung Galaxy S24",
     "brand": "Samsung",
     "price": 999,
     "rating": 4.8
   }
   ```
3. **Get prediction:**
   ```json
   {
     "category": "Electronics",
     "confidence": 0.94
   }
   ```
4. **Done!** Product is automatically categorized.

---

## Technical Stack (Tools We Used)

| Tool | Purpose |
|------|---------|
| **LightGBM** | Machine learning model |
| **MLflow** | Experiment tracking & model registry |
| **Prefect** | Pipeline orchestration |
| **FastAPI** | Web API framework |
| **Docker** | Containerization |
| **GitHub Actions** | CI/CD automation |
| **AWS** | Cloud deployment |

---

## Project Structure (Simple View)

```
mlops-product-classification/
├── src/
│   ├── data/          → Load & clean data
│   ├── features/      → Build features
│   ├── models/        → Train model
│   ├── inference/     → API for predictions
│   └── workflows/     → Automated pipeline
├── tests/             → Quality assurance
├── docker/            → Container configs
└── .github/workflows/ → Automation
```

---

## How to Use It (For Your Team)

### For Developers:
1. **Run training:** `python src/main.py`
2. **Start API:** `python -m uvicorn src.inference.api:app`
3. **View MLflow:** Open `http://localhost:5000`

### For Business People:
- **What it does:** Categorizes products automatically
- **Why it matters:** Saves time, reduces errors
- **How to use:** Send product info to API, get category back

---

## Key Metrics

- **Accuracy:** ~85-90% (varies by category)
- **Features:** 19 engineered features
- **Data:** 10,000+ products
- **Categories:** Multiple (Electronics, Clothing, Home & Garden, etc.)
- **Response Time:** <100ms per prediction

---

## What's Next?

1. **Deploy to AWS** (we have the setup ready)
2. **Add monitoring** (track model performance over time)
3. **Improve model** (try different algorithms, more data)
4. **Scale up** (handle millions of products)

---

## Summary (One Sentence)

**We built an automated system that categorizes products using machine learning, with full experiment tracking, automated pipelines, and a production-ready API that can be deployed to the cloud.**

---

**Questions?** Check the README.md or ask the team!

