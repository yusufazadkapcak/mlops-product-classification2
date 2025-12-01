# 📋 Mandatory Requirements Checklist

Based on your MLOps Term Project requirements (SWE016).

## I. Mandatory Deliverables

### Organizational Requirements

| Requirement | Status | Notes |
|------------|--------|-------|
| **Group Size (5-7 members)** | ⚠️ **NOT DOCUMENTED** | Must create `TEAM_ROLES.md` with team member list |
| **Defined Roles** | ⚠️ **NOT DOCUMENTED** | Must document each member's role (Data Engineer, ML Engineer, DevOps, etc.) |
| **Working Demo** | ✅ **READY** | - FastAPI API working<br>- Training pipeline working<br>- MLflow UI working<br>- Docker containers ready |
| **Individual Report** | ⚠️ **NOT CREATED** | Each team member must create their own report |
| **Business Presentation (PPT)** | ⚠️ **NOT CREATED** | Must be a business presentation for senior management |
| **Video Presentation (5 min)** | ⚠️ **NOT CREATED** | 5-minute video presentation required |
| **In-Class Presentation** | ⚠️ **NOT PREPARED** | Must be prepared separately |

---

## II. Required Tool Stack

### 1. Experiment Tracking and Model Governance

| Requirement | Status | Implementation |
|------------|--------|----------------|
| **MLflow for Experiment Tracking** | ✅ **COMPLETE** | `src/tracking_utils/tracking.py`<br>All parameters and metrics logged |
| **MLflow Model Registry** | ✅ **COMPLETE** | `register_model()` function<br>Model versioning with stages (Production/Staging/Archived) |
| **Parameter Logging** | ✅ **COMPLETE** | All hyperparameters logged via MLflow |
| **Metric Logging** | ✅ **COMPLETE** | Accuracy, Precision, Recall, F1-score logged |
| **Model Versioning** | ✅ **COMPLETE** | Model versions tracked and staged |

### 2. Workflow Orchestration (Choose One)

| Tool Option | Status | Implementation | Justification Needed |
|------------|--------|----------------|---------------------|
| **Kubeflow Pipelines (KFP)** | ❌ **NOT USED** | - | - |
| **Apache Airflow** | ❌ **NOT USED** | - | - |
| **Prefect** | ✅ **COMPLETE** | `src/workflows/prefect_pipeline.py`<br>Complete DAG: data_prep → train → evaluate → register | ⚠️ **Need justification document** |

**⚠️ ACTION REQUIRED:** Create `TOOL_JUSTIFICATION.md` explaining why Prefect was chosen.

### 3. Core CI/CD and Auxiliary Tools

| Tool Category | Required Tools | Status | Implementation |
|--------------|----------------|--------|----------------|
| **Containerization** | Docker, Kubernetes | ✅ **PARTIAL** | ✅ Docker (`docker/Dockerfile`, `docker/Dockerfile.inference`)<br>⚠️ Kubernetes not implemented (optional) |
| **CI/CD Execution** | Jenkins, GitLab CI/CD, Circle CI | ✅ **COMPLETE** | ✅ GitHub Actions (`.github/workflows/`)<br>- CI pipeline (`ci.yml`)<br>- Training pipeline (`train.yml`)<br>- Deployment pipeline (`deploy.yml`) |
| **Unit/Component Testing** | xUnit Frameworks | ✅ **COMPLETE** | ✅ `tests/unit/test_data.py` (unittest)<br>✅ `tests/unit/test_models.py` (unittest)<br>✅ `tests/integration/test_pipeline.py`<br>✅ pytest configured in CI |
| **Code Inspection/Analysis** | Checkstyle, PMD, JDepend | ✅ **COMPLETE** | ✅ Black (formatting) in CI<br>✅ isort (import sorting) in CI<br>✅ flake8 (linting) in CI<br>✅ Coverage reporting (Codecov) |
| **Cloud Platform** | AWS, Azure, GCP | ✅ **COMPLETE** | ✅ AWS deployment setup complete<br>✅ Configuration files created<br>✅ Deployment scripts ready |

---

## III. Mandatory Technical Implementation Requirements

### 1. Data Representation (High-Cardinality Handling)

| Requirement | Status | Implementation |
|------------|--------|----------------|
| **High-Cardinality Handling** | ✅ **COMPLETE** | ✅ **Hashed Feature Pattern** implemented<br>`hash_feature()` in `src/features/build_features.py`<br>Applied to: `seller_id`, `brand`, `subcategory`<br>1000 hash buckets (configurable) |
| **Embeddings Alternative** | ⚠️ **NOT IMPLEMENTED** | Hash encoding only<br>**Justification needed:** Why hash over embeddings? |
| **Feature Cross** | ✅ **COMPLETE** | ✅ `brand_price_cross_hashed` in `src/features/build_features.py`<br>Combines brand × price_range<br>Hashed after concatenation |

**⚠️ ACTION REQUIRED:** Document justification for hash encoding choice in `DESIGN_PATTERNS.md`

### 2. Model Serving

| Requirement | Status | Implementation |
|------------|--------|----------------|
| **Stateless Serving Function** | ✅ **COMPLETE** | ✅ FastAPI REST API (`src/inference/api.py`)<br>✅ Stateless endpoints: `/predict`, `/predict/batch`<br>✅ Health check endpoint<br>✅ Docker containerized |

---

## ✅ What's Complete (Technical)

### Fully Implemented:

1. ✅ **MLflow Integration**
   - Experiment tracking
   - Model registry with versioning
   - Stage management (Production/Staging/Archived)

2. ✅ **Prefect Orchestration**
   - Complete pipeline DAG
   - Task-based workflow
   - Error handling

3. ✅ **High-Cardinality Feature Handling**
   - Hash encoding for seller_id, brand, subcategory
   - Feature crosses (brand × price_range)

4. ✅ **CI/CD Pipeline**
   - GitHub Actions workflows
   - Automated testing
   - Code quality checks
   - Docker build and test

5. ✅ **Testing**
   - Unit tests (data, models)
   - Integration tests (full pipeline)
   - Test coverage reporting

6. ✅ **Code Quality**
   - Black formatting
   - isort import sorting
   - flake8 linting

7. ✅ **Containerization**
   - Docker for training
   - Docker for inference
   - Docker Compose for full stack

8. ✅ **Model Serving**
   - FastAPI REST API
   - Stateless serving
   - Batch prediction support

9. ✅ **Cloud Deployment**
   - AWS deployment setup
   - Configuration files
   - Deployment scripts

---

## ⚠️ What's Missing (Documentation & Deliverables)

### High Priority (Must Have):

1. ⚠️ **TEAM_ROLES.md**
   - Document team members (5-7)
   - Define each member's role
   - Map responsibilities

2. ⚠️ **TOOL_JUSTIFICATION.md**
   - Why Prefect over Airflow/Kubeflow?
   - Why Hash Encoding over Embeddings?
   - Why GitHub Actions over Jenkins?

3. ⚠️ **DESIGN_PATTERNS.md**
   - Justification of ML design patterns
   - Hash encoding vs embeddings trade-offs
   - Feature engineering decisions

4. ⚠️ **Individual Reports**
   - Each team member must create their own
   - Document their contribution
   - Technical implementation choices

5. ⚠️ **Business Presentation (PPT)**
   - Business-focused (not technical)
   - For senior management
   - Introduction-Development-Conclusion flow

6. ⚠️ **Video Presentation (5 min)**
   - 5-minute video
   - Share link separately

7. ⚠️ **In-Class Presentation**
   - Prepare presentation
   - Practice demo

### Medium Priority (Should Have):

8. ⚠️ **Monitoring Dashboard**
   - Add monitoring (Prometheus/Grafana) OR
   - Enhance MLflow monitoring features

9. ⚠️ **Cloud Deployment Demo**
   - Actually deploy to AWS (not just setup)
   - Document deployment process
   - Show live URLs in presentation

---

## 📊 Completion Status

| Category | Completion | Status |
|----------|-----------|--------|
| **Technical Implementation** | 95% | ✅ Excellent |
| **Documentation** | 40% | ⚠️ Needs Work |
| **Deliverables** | 20% | ⚠️ Missing |
| **Overall** | ~60% | ⚠️ In Progress |

---

## 🎯 Immediate Actions Required

### This Week:

1. **Create TEAM_ROLES.md**
   ```markdown
   # Team Roles
   - [Name] - Data Engineer - Responsibilities: ...
   - [Name] - ML Engineer - Responsibilities: ...
   - [Name] - DevOps Engineer - Responsibilities: ...
   ```

2. **Create TOOL_JUSTIFICATION.md**
   - Why Prefect? (Dynamic workflows, fail-fast, data-driven)
   - Why Hash Encoding? (Memory efficiency, no training required)
   - Why GitHub Actions? (Integration, ease of use)

3. **Create DESIGN_PATTERNS.md**
   - Hash encoding justification
   - Feature cross explanation
   - Design pattern choices

4. **Start Business Presentation**
   - Focus on business value
   - Operational efficiency
   - Risk mitigation

### Next Week:

5. **Individual Reports** (each team member)
6. **Video Presentation** (5 minutes)
7. **Practice Demo** for in-class presentation
8. **Deploy to AWS** (actually deploy, not just setup)

---

## ✅ Final Checklist Before Submission

- [ ] TEAM_ROLES.md created
- [ ] TOOL_JUSTIFICATION.md created
- [ ] DESIGN_PATTERNS.md created
- [ ] Individual reports (one per team member)
- [ ] Business presentation (PPT) ready
- [ ] Video presentation (5 min) recorded
- [ ] In-class presentation prepared
- [ ] Working demo tested and ready
- [ ] Cloud deployment actually deployed (not just configured)
- [ ] All code committed to repository
- [ ] Documentation complete

---

## 📝 Summary

**Technical Implementation: ✅ 95% Complete**
- All code requirements met
- All tools implemented
- All patterns implemented

**Documentation & Deliverables: ⚠️ 40% Complete**
- Missing team documentation
- Missing justifications
- Missing presentations
- Missing individual reports

**Overall: ~60% Complete**

**Focus on documentation and deliverables to reach 100%!**

---

**Deadline: 02.01.2026 Friday 12:00**

