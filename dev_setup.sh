#!/bin/bash

set -e


read -p "📁 Enter your project name: " PROJECT_NAME
read -p "🐍 Enter Conda environment name: " ENV_NAME
read -p "🔢 Python version (e.g., 3.10): " PYTHON_VERSION

read -p "📁 Enter base path for your project (default: ~/Documents/Projects): " BASE_PATH
BASE_PATH="${BASE_PATH:-$HOME/Documents/Projects}"

mkdir -p "$BASE_PATH/$PROJECT_NAME"
cd "$BASE_PATH/$PROJECT_NAME"

mkdir -p data/{raw,processed}
mkdir -p notebooks/{exploratory,modeling}
mkdir -p outputs/figures
mkdir -p models
mkdir -p src/{app,analysis,features_engineering,preprocessing,dataset,modeling}
mkdir -p src/tests/unit
mkdir -p admin
touch README.md requirements.txt
touch src/analysis/analysis_base_class.py
touch src/features_engineering/__init__.py
touch src/preprocessing/__init__.py
touch src/dataset/__init__.py
touch src/modeling/__init__.py
touch src/app/__init__.py
touch src/tests/unit/test_placeholder.py

cat <<EOT > requirements.txt
pandas
numpy
pydantic
matplotlib
seaborn
plotly
scipy
statsmodels
scikit-learn
pca
notebook
jupyter
EOT

echo "🧪 Initializing Git..."
git init
cat <<EOL > .gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
# .python-version

# pipenv
#Pipfile.lock

# UV
#uv.lock

# poetry
#poetry.lock

# pdm
.pdm.toml
.pdm-python
.pdm-build/

# PEP 582
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#.idea/

# Ruff stuff:
.ruff_cache/

# PyPI configuration file
.pypirc

# ignore all .DS_Store files
**/.DS_Store
EOL

git add .
git commit -m "Initial project structure"

echo "🐍 Setting up Conda environment '$ENV_NAME'..."
source "$(conda info --base)/etc/profile.d/conda.sh"
conda create -n "$ENV_NAME" python="$PYTHON_VERSION" -y
conda activate "$ENV_NAME"

pip install -r requirements.txt
python -m ipykernel install --user --name="$ENV_NAME" --display-name "Python ($ENV_NAME)"

mkdir -p .vscode
cat <<EOL > .vscode/settings.json
{
  "python.defaultInterpreterPath": "$HOME/anaconda3/envs/$ENV_NAME/bin/python",
  "python.terminal.activateEnvironment": true,
  "python.envFile": "\${workspaceFolder}/.env",
  "jupyter.notebookFileRoot": "\${workspaceFolder}"
}
EOL

cat <<EOL > "$BASE_PATH/$PROJECT_NAME/admin/teardown.sh"
#!/bin/bash

set -e

EXPECTED_ROOT="$BASE_PATH"

echo "⚠️ WARNING: This will permanently delete the Conda environment '$ENV_NAME' and the project folder."
echo ""

read -p "Are you absolutely sure? Type 'yes' to continue: " CONFIRM
if [[ "\$CONFIRM" != "yes" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

read -p "Last chance! Type 'delete' to confirm: " FINAL_CONFIRM
if [[ "\$FINAL_CONFIRM" != "delete" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

# Resolve project path (admin/..)
PROJECT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"

# Safety check: ensure deletion only happens within the expected root path
if [[ "\$PROJECT_DIR" != "\$EXPECTED_ROOT/"* ]]; then
  echo "❌ Aborting: Project directory is outside the allowed path (\$EXPECTED_ROOT)."
  exit 1
fi

# Remove Conda environment
echo "🧼 Removing Conda environment '$ENV_NAME'..."
conda remove --name "$ENV_NAME" --all -y || echo "⚠️ Conda environment not found."

# Remove Jupyter kernel
if jupyter kernelspec list | grep -q "$ENV_NAME"; then
  echo "🧠 Removing Jupyter kernel '$ENV_NAME'..."
  jupyter kernelspec remove "$ENV_NAME" -f
fi

# Final confirmation before deletion
read -p "Are you sure you want to delete the project folder at \"\$PROJECT_DIR\"? Type 'yes' to confirm: " DELETE_CONFIRM
if [[ "\$DELETE_CONFIRM" != "yes" ]]; then
  echo "❌ Cancelled."
  exit 1
fi

# Delete the project folder
rm -rf "\$PROJECT_DIR"
echo "✅ Environment and project folder deleted."
EOL


echo "✅ Project \'\$PROJECT_NAME\' is fully set up!"
echo "👉 Open it in VSCode with: code ."
echo "🔁 To activate your environment later: conda activate $ENV_NAME"
