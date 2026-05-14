import json
import random
import os
import argparse
from datetime import datetime, timedelta

def generate_record(user_id):
    levels = ["INFO", "WARN", "ERROR", "DEBUG"]
    messages = [
        "User logged in",
        "Page view: /home",
        "Page view: /settings",
        "Data export started",
        "Connection lost",
        "Authentication failed",
        "Cache cleared",
        "New item added to cart"
    ]
    
    timestamp = (datetime.now() - timedelta(minutes=random.randint(0, 1000))).isoformat() + "Z"
    
    return {
        "timestamp": timestamp,
        "level": random.choice(levels),
        "message": random.choice(messages),
        "user_id": user_id,
        "ip_address": f"192.168.1.{random.randint(1, 254)}"
    }

def main():
    parser = argparse.ArgumentParser(description="Generate test JSON logs.")
    parser.add_argument("--num_files", type=int, default=5, help="Number of files to generate")
    parser.add_argument("--records_per_file", type=int, default=10, help="Records per file")
    parser.add_argument("--output_dir", type=str, default="/dataflow_demo_data/input", help="Output directory")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir, exist_ok=True)
        
    for i in range(args.num_files):
        file_path = os.path.join(args.output_dir, f"generated_logs_{i+1}.json")
        print(f"Generating {file_path}...")
        with open(file_path, "w") as f:
            for _ in range(args.records_per_file):
                user_id = random.randint(100, 999)
                record = generate_record(user_id)
                f.write(json.dumps(record) + "\n")

if __name__ == "__main__":
    main()
