#!/bin/bash

# Configuration
BUCKET_NAME="dataflow_demo_data"
MOUNT_POINT="/dataflow_demo_data"

echo "Setting up GCS mount for bucket: $BUCKET_NAME at $MOUNT_POINT"

# Create mount point if it doesn't exist
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point $MOUNT_POINT..."
    sudo mkdir -p "$MOUNT_POINT"
    sudo chown $(whoami) "$MOUNT_POINT"
fi

# Check if already mounted
if mount | grep -q "$MOUNT_POINT"; then
    echo "Bucket is already mounted at $MOUNT_POINT."
else
    echo "Mounting bucket with --implicit-dirs..."
    gcsfuse --implicit-dirs "$BUCKET_NAME" "$MOUNT_POINT"
    
    if [ $? -eq 0 ]; then
        echo "Mount successful."
    else
        echo "Error: Mount failed. Please check gcsfuse installation and permissions."
        exit 1
    fi
fi

echo "---"
ls -l "$MOUNT_POINT"
