#!/bin/bash

# Get absolute paths
BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( dirname "$BIN_DIR" )"
VENV="$PROJECT_DIR/.venv"

# Check for virtual environment
if [ ! -d "$VENV" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install --upgrade pip
    "$VENV/bin/pip" install -e "$PROJECT_DIR"
fi

# Run the generator
"$VENV/bin/python3" "$BIN_DIR/generate_test_data.py" "$@"
