# Project Context: PX Demo

This project demonstrates a log processing pipeline using Python and SkyPilot/PX to convert JSON logs stored in Google Cloud Storage (GCS) to Avro format.

## Architecture Overview

The project is designed to run both locally (for testing) and on a distributed PX cluster.

- **Data Source:** GCS bucket `gs://dataflow_demo_data`.
- **Mount Point:** Both local and remote environments use `/dataflow_demo_data` as the standard mount point.
- **Processing:** A native Python script (`json_to_avro_px.py`) converts JSON to Avro.
- **Output:** 
  - Local: `/dataflow_demo_data/local_px_output`
  - Cluster: `/dataflow_demo_data/cluster_px_output`

## Environment Setup

### 1. Local GCS Mount
To run the project locally, you must mount the GCS bucket. Crucially, you **must** use the `--implicit-dirs` flag because the bucket structure is object-based.

```bash
sudo mkdir -p /dataflow_demo_data
sudo chown $(whoami) /dataflow_demo_data
gcsfuse --implicit-dirs dataflow_demo_data /dataflow_demo_data
```

### 2. Virtual Environment
The project uses a `.venv` directory for isolation.

- **Local:** Run the following to set up:
  ```bash
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r requirements.txt
  ```
- **Remote (Cluster):** Managed via `px.yaml`. The `setup` step automatically creates the `.venv` and installs requirements on every node.

## Running the Project

### Local Execution
Use `bin/run_px.sh`. It will attempt to process all logs found in `/dataflow_demo_data/input/`.
```bash
bash bin/run_px.sh
```

### Cluster Execution
Use `bin/run_cluster.sh`. 
**Note:** This script expands the file glob **locally**. If your local mount is broken, the job submission will fail because it will send a literal `*` string to the cluster.
```bash
bash bin/run_cluster.sh [cluster_name]
```

## Key Files

- `px.yaml`: Configuration for SkyPilot/PX (nodes, resources, setup).
- `requirements.txt`: Python dependencies (keep this synced with `pyproject.toml`).
- `json_to_avro_px.py`: The core processing logic.
- `bin/`: Shell scripts for orchestration.

## Common Gotchas

1. **Empty Mounts:** If `/dataflow_demo_data/input` appears empty locally, ensure you used `--implicit-dirs` with `gcsfuse`.
2. **Venv Paths:** The scripts expect the virtual environment at the project root (`.venv`). If you change this, update `px.yaml` and `bin/run_px.sh`.
3. **Cluster Sync:** After changing `px.yaml` or code, you may need to run `px cluster sync --run-setup` to apply changes to an existing cluster.
