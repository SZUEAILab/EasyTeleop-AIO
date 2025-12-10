#!/bin/bash

echo "Installing and starting EMQX MQTT server..."

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Error: Docker is not installed or not in PATH."
    echo "Please install Docker from https://docs.docker.com/get-docker/"
    exit 1
fi

echo "Pulling EMQX Enterprise Docker image..."
if ! docker pull emqx/emqx-enterprise:6.0.1; then
    echo "Error: Failed to pull EMQX Docker image."
    exit 1
fi

echo "Starting EMQX Enterprise container..."
if ! docker run -d \
  --name emqx-enterprise \
  -p 1883:1883 \
  -p 8083:8083 \
  -p 8084:8084 \
  -p 8883:8883 \
  -p 18083:18083 \
  emqx/emqx-enterprise:6.0.1; then
  
    echo "Error: Failed to start EMQX container."
    exit 1
fi

echo "EMQX MQTT server successfully started!"
echo "Container name: emqx-enterprise"
echo "Ports mapped:"
echo " - MQTT: 1883"
echo " - WebSocket: 8083"
echo " - SSL WebSocket: 8084"
echo " - MQTT SSL: 8883"
echo " - Dashboard: 18083"
echo ""
echo "You can access the dashboard at http://localhost:18083"