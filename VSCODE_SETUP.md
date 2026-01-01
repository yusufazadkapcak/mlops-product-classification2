# VS Code Setup Guide

This project is fully configured for Visual Studio Code with all necessary settings, extensions, and launch configurations.

## 🎯 What's Included

### 1. VS Code Settings (`.vscode/settings.json`)
- Python interpreter configuration
- Code formatting with Black
- Import sorting with isort
- Linting with flake8
- Pytest test configuration
- File exclusions for clean workspace

### 2. Launch Configurations (`.vscode/launch.json`)
Pre-configured debug configurations for:
- **Main Training Pipeline**: Run and debug `src/main.py`
- **Prefect Pipeline**: Run and debug the Prefect workflow
- **FastAPI Inference**: Start the API server with debugging
- **Generate Sample Data**: Run the data generation script
- **Current File**: Debug any Python file
- **Pytest**: Run tests with debugging

### 3. Tasks (`.vscode/tasks.json`)
Quick tasks accessible via `Ctrl+Shift+P` → "Tasks: Run Task":
- Install Dependencies
- Generate Sample Data
- Run Training Pipeline
- Run Tests (with/without coverage)
- Start MLflow Server
- Start FastAPI Server
- Format Code (Black)
- Sort Imports (isort)

### 4. Recommended Extensions (`.vscode/extensions.json`)
Auto-suggested extensions:
- Python (ms-python.python)
- Pylance (ms-python.vscode-pylance)
- Black Formatter (ms-python.black-formatter)
- isort (ms-python.isort)
- Flake8 (ms-python.flake8)
- Docker (ms-azuretools.vscode-docker)
- YAML (redhat.vscode-yaml)
- Pytest (ms-python.pytest)

## 🚀 Quick Start in VS Code

### 1. Open the Project
```bash
code mlops-product-classification
```

### 2. Install Recommended Extensions
VS Code will prompt you to install recommended extensions, or:
- Press `Ctrl+Shift+X` to open Extensions
- Search for "Recommended" to see suggested extensions

### 3. Set Up Python Environment
1. Create a virtual environment:
   ```bash
   python -m venv venv
   ```

2. Activate it:
   - Windows: `venv\Scripts\activate`
   - Linux/Mac: `source venv/bin/activate`

3. Install dependencies:
   - Use the task: `Ctrl+Shift+P` → "Tasks: Run Task" → "Install Dependencies"
   - Or manually: `pip install -r requirements.txt`

### 4. Select Python Interpreter
- Press `Ctrl+Shift+P`
- Type "Python: Select Interpreter"
- Choose the venv interpreter

## 🎮 Using Debug Configurations

### Run Training Pipeline
1. Open `src/main.py`
2. Press `F5` or go to Run → Start Debugging
3. Select "Python: Main Training Pipeline"
4. Set breakpoints as needed

### Debug API
1. Open `src/inference/api.py`
2. Press `F5`
3. Select "Python: FastAPI Inference"
4. API will start with hot-reload enabled

### Debug Tests
1. Open any test file
2. Press `F5`
3. Select "Python: Pytest"
4. Tests will run with debugging enabled

## 📋 Using Tasks

### Quick Access
- `Ctrl+Shift+P` → "Tasks: Run Task"
- Select the task you want

### Common Tasks

**Generate Sample Data:**
```
Tasks: Run Task → Generate Sample Data
```

**Run Training:**
```
Tasks: Run Task → Run Training Pipeline
```

**Run Tests:**
```
Tasks: Run Task → Run Tests
```

**Start MLflow:**
```
Tasks: Run Task → Start MLflow Server
```
(Note: This runs in background, check terminal output)

**Start FastAPI:**
```
Tasks: Run Task → Start FastAPI Server
```
(Note: This runs in background, check terminal output)

## 🔧 Code Formatting

### Auto-format on Save
Formatting is enabled automatically when you save files.

### Manual Formatting
- Format entire project: `Tasks: Run Task → Format Code (Black)`
- Sort imports: `Tasks: Run Task → Sort Imports (isort)`

### Format Selection
- Select code
- Right-click → "Format Selection"
- Or `Shift+Alt+F`

## 🧪 Running Tests

### Run All Tests
- `Tasks: Run Task → Run Tests`
- Or: `Ctrl+Shift+P` → "Python: Run All Tests"

### Run Specific Test
- Click the "Run Test" link above any test function
- Or use the Test Explorer (beaker icon in sidebar)

### Debug Tests
- Set breakpoints in test files
- Press `F5` → Select "Python: Pytest"

## 📁 Project Structure in VS Code

The workspace is configured to:
- Hide cache files (`__pycache__`, `.pytest_cache`, etc.)
- Hide MLflow runs (`mlruns/`)
- Show only relevant files

### File Explorer Tips
- Use `Ctrl+P` for quick file search
- Use `Ctrl+Shift+F` for global search
- Use `Ctrl+Shift+E` to focus on Explorer

## 🐛 Debugging Tips

### Setting Breakpoints
- Click in the gutter (left of line numbers)
- Or press `F9` on a line

### Debug Console
- Use the Debug Console to evaluate expressions
- Access variables in the current scope

### Step Through Code
- `F10`: Step over
- `F11`: Step into
- `Shift+F11`: Step out
- `F5`: Continue

## 📝 Code Intelligence

### IntelliSense
- Auto-completion for imports
- Type hints and docstrings
- Go to definition (`F12`)
- Peek definition (`Alt+F12`)

### Import Organization
- Imports are automatically sorted on save
- Uses Black-compatible profile

## 🔍 Search & Navigation

### Quick Open
- `Ctrl+P`: Open file by name
- `Ctrl+Shift+P`: Command palette

### Go to Symbol
- `Ctrl+Shift+O`: Go to symbol in file
- `Ctrl+T`: Go to symbol in workspace

### Find References
- `Shift+F12`: Find all references
- `Alt+F12`: Peek references

## 💡 Pro Tips

1. **Multi-cursor Editing**: `Alt+Click` to add cursors
2. **Column Selection**: `Alt+Shift+Drag` for column selection
3. **Command Palette**: `Ctrl+Shift+P` for all commands
4. **Integrated Terminal**: `` Ctrl+` `` to toggle terminal
5. **Split Editor**: `Ctrl+\` to split editor
6. **Zen Mode**: `Ctrl+K Z` for distraction-free coding

## 🎨 Customization

All settings can be customized in `.vscode/settings.json`:
- Change formatter
- Adjust line length
- Modify test framework
- Add custom tasks

## 📚 Additional Resources

- [VS Code Python Documentation](https://code.visualstudio.com/docs/languages/python)
- [Python Extension Guide](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
- [Debugging in VS Code](https://code.visualstudio.com/docs/editor/debugging)

## ✅ Verification Checklist

- [ ] VS Code opened the project
- [ ] Recommended extensions installed
- [ ] Python interpreter selected (venv)
- [ ] Dependencies installed
- [ ] Can run training pipeline (F5)
- [ ] Can run tests
- [ ] Code formatting works on save
- [ ] IntelliSense is working

Happy coding! 🚀




