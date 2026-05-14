#!/bin/bash

# Configuration
CLUSTER_NAME=${1:-my-cluster2}
PARALLEL_PROCS=2

# Get the list of files to process from the mount
# We use the absolute path /dataflow_demo_data/input/ which is consistent
# across your local WSL2 and the PX cluster nodes.
FILES=( /dataflow_demo_data/input/sample_logs_*.json )

if [ ${#FILES[@]} -eq 0 ]; then
    echo "No files found in /dataflow_demo_data/input/"
    exit 1
fi

echo "Submitting job to PX cluster: $CLUSTER_NAME"
echo "Processing ${#FILES[@]} files with parallelism $PARALLEL_PROCS"

# Pipe the list of files to px job submit
# The command inside the cluster will use the local virtual environment
printf "%s\n" "${FILES[@]}" | px job submit -c "$CLUSTER_NAME" -p "$PARALLEL_PROCS" \
    'while read file; do .venv/bin/python3 json_to_avro_px.py "$file" --output_dir /dataflow_demo_data/cluster_px_output; done'

echo "--------------------------------------------------------"
echo "Job submission complete."
echo "You can check the job status with: px job status -c $CLUSTER_NAME"
