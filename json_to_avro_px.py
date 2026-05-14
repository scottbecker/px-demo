import argparse
import json
import logging
import os
import fastavro

# Define the Avro schema
AVRO_SCHEMA = {
    "type": "record",
    "name": "LogRecord",
    "fields": [
        {"name": "timestamp", "type": "string"},
        {"name": "level", "type": "string"},
        {"name": "message", "type": "string"},
        {"name": "user_id", "type": "int"},
        {"name": "ip_address", "type": "string"}
    ]
}

def process_file(input_path, output_dir):
    # Determine output filename based on input filename
    base_name = os.path.basename(input_path)
    file_name_no_ext = os.path.splitext(base_name)[0]
    output_path = os.path.join(output_dir, f"{file_name_no_ext}.avro")
    
    logging.info(f"Processing {input_path} -> {output_path}")
    
    # Read JSON records
    records = []
    try:
        with open(input_path, 'r') as f:
            for line in f:
                if line.strip():
                    records.append(json.loads(line))
        
        # Write to Avro using fastavro directly
        with open(output_path, 'wb') as out:
            fastavro.writer(out, AVRO_SCHEMA, records)
            
    except Exception as e:
        logging.error(f"Failed to process {input_path}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Process JSON logs to Avro using native Python (no Beam).")
    parser.add_argument(
        'inputs',
        nargs='+',
        help='List of JSON files to process.')
    parser.add_argument(
        '--output_dir',
        default='/dataflow_demo_data/local_px_output',
        help='Directory to place finished Avro files.')
    
    args = parser.parse_args()

    # Ensure output directory exists
    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir, exist_ok=True)

    for input_file in args.inputs:
        if os.path.exists(input_file):
            process_file(input_file, args.output_dir)
        else:
            logging.error(f"File not found: {input_file}")

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    main()
