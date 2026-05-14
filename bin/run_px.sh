#!/bin/bash

# Get absolute paths
BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( dirname "$BIN_DIR" )"
DATAFLOW_VENV="$PROJECT_DIR/.venv"

# Check for virtual environment
if [ ! -d "$DATAFLOW_VENV" ]; then
    echo "Error: Virtual environment not found at $DATAFLOW_VENV."
    exit 1
fi

# Activate virtual environment
source "$DATAFLOW_VENV/bin/activate"

# If no arguments provided, use all sample logs from the mount
if [ $# -eq 0 ]; then
    echo "No files provided. Processing all sample logs in /dataflow_demo_data/input/ ..."
    FILES=( /dataflow_demo_data/input/sample_logs_*.json )
else
    FILES=("$@")
fi

echo "Starting sequential processing of ${#FILES[@]} files..."

# Run the Python script with the list of files
python3 "$PROJECT_DIR/json_to_avro_px.py" "${FILES[@]}"

echo "Processing complete. Check /dataflow_demo_data/local_px_output/ for results."
