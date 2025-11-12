#!/bin/bash

echo "Starting EasyTeleop Node Service..."
echo "==================================="

if [ ! -d "EasyTeleop-Node" ]; then
    echo "Error: EasyTeleop-Node directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

cd EasyTeleop-Node
echo "Running Node service..."
uv run node.py
cd ..

echo "Node service stopped."