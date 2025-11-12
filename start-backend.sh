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
python3 backend.py &

sleep 2

echo "Starting MQTT sync service..."
python3 run_mqtt_sync.py &

cd ..

echo "Backend services started."
echo "Press Ctrl+C to stop the services"
wait