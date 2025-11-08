#!/usr/bin/env bash
set -euo pipefail

# Bootstrap local development environment for SuperAGI
# - ensures python3 and pip are available
# - creates a virtualenv at .venv
# - installs requirements.txt
# - retries with legacy resolver and tries to pin typing-extensions if conflicts mention it

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="$ROOT_DIR/.venv"
REQUIREMENTS_FILE="$ROOT_DIR/requirements.txt"

echo "[bootstrap] Root dir: $ROOT_DIR"

command -v python3 >/dev/null 2>&1 || {
  echo "python3 not found. Please install Python 3.8+ and re-run." >&2
  exit 1
}

# ensure pip exists
if ! command -v pip3 >/dev/null 2>&1; then
  echo "pip3 not found. Attempting to install pip..."
  curl -sS https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
  python3 /tmp/get-pip.py --disable-pip-version-check
fi

echo "Using python: $(python3 --version)" 
echo "Using pip: $(pip3 --version)" 

# create venv if missing
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating virtualenv at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi

activate() {
  # shellcheck disable=SC1090
  source "$VENV_DIR/bin/activate"
}

activate
pip install --upgrade pip setuptools wheel

if [ ! -f "$REQUIREMENTS_FILE" ]; then
  echo "Requirements file not found at $REQUIREMENTS_FILE" >&2
  exit 1
fi

echo "Installing requirements from $REQUIREMENTS_FILE (first attempt)"
if pip install -r "$REQUIREMENTS_FILE"; then
  echo "Requirements installed successfully."
  exit 0
fi

echo "Initial install failed. Trying fallback strategies..."

# Strategy 1: retry with legacy resolver (helps with some pinned conflicts)
echo "Retrying with legacy resolver"
if pip install --use-deprecated=legacy-resolver -r "$REQUIREMENTS_FILE"; then
  echo "Installed using legacy resolver."
  exit 0
fi

# Strategy 2: detect typing-extensions conflict and try compatible pin
echo "Analyzing error for typing-extensions conflicts..."
CONFLICTS=$(pip install -r "$REQUIREMENTS_FILE" 2>&1 || true)
if echo "$CONFLICTS" | grep -qi "typing-extensions"; then
  echo "Detected typing-extensions conflict. Attempting to install a compatible version 4.5.0 then re-run."
  pip install "typing-extensions==4.5.0" || true
  if pip install -r "$REQUIREMENTS_FILE"; then
    echo "Installed after pinning typing-extensions."
    exit 0
  fi
fi

echo "Automatic fixes didn't resolve all dependency issues."
echo "You can inspect the virtualenv at $VENV_DIR and try to resolve conflicts manually."
echo "Last pip output:"
echo "$CONFLICTS"
exit 2
