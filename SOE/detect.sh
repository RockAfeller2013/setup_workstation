#!/bin/bash
set -e

# Check if NVIDIA GPU is present
GPU_COUNT=$(lspci | grep -i nvidia | wc -l)

if [ "$GPU_COUNT" -eq 0 ]; then
    echo "No NVIDIA GPU detected."
    exit 1
else
    echo "NVIDIA GPU(s) detected: $GPU_COUNT"
    lspci | grep -i nvidia
fi

# Check if NVIDIA driver is loaded
if command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA driver is installed. Status:"
    nvidia-smi
else
    echo "NVIDIA driver not installed or not loaded."
fi
