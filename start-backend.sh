#!/bin/bash

echo "Starting EasyTeleop Backend Service..."
echo "======================================"

if [ ! -d "EasyTeleop-Backend-Python" ]; then
    echo "Error: EasyTeleop-Backend-Python directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

cd EasyTeleop-Backend-Python

echo "Starting main backend service..."
uv run backend.py

cd ..

echo "Backend service stopped."
echo "Press Ctrl+C to stop the services"
wait