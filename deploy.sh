#!/bin/bash

echo "EasyTeleop AIO Deployment Script for Unix/Linux/Mac"
echo "=================================================="

# Sync submodules
echo "[0/3] Syncing submodules..."
git submodule update --init --recursive
if [ $? -ne 0 ]; then
    echo "Error syncing submodules"
    exit 1
fi

# Check if running from the correct directory
if [ ! -d "EasyTeleop-Node" ]; then
    echo "Error: EasyTeleop-Node directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

if [ ! -d "EasyTeleop-Backend-Python" ]; then
    echo "Error: EasyTeleop-Backend-Python directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

if [ ! -d "EasyTeleopFrontend" ]; then
    echo "Error: EasyTeleopFrontend directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

echo "[1/3] Installing EasyTeleop-Node dependencies..."
cd EasyTeleop-Node
if [ ! -f "uv.lock" ]; then
    echo "Warning: uv.lock not found. Will create new lock file."
fi

# Install uv if not present
if ! python3 -c "import uv" &> /dev/null; then
    echo "Installing uv..."
    pip3 install uv
fi

uv sync
if [ $? -ne 0 ]; then
    echo "Error installing Node dependencies"
    cd ..
    exit 1
fi
cd ..

echo "[2/3] Installing EasyTeleop-Backend-Python dependencies..."
cd EasyTeleop-Backend-Python
# Install requirements
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt
else
    echo "Warning: requirements.txt not found, trying pyproject.toml"
    if ! python3 -c "import tomli" &> /dev/null; then
        pip3 install tomli
    fi
    if ! python3 -c "import tomli_w" &> /dev/null; then
        pip3 install tomli_w
    fi
    uv sync
fi

if [ $? -ne 0 ]; then
    echo "Error installing Backend dependencies"
    cd ..
    exit 1
fi
cd ..

echo "[3/3] Installing EasyTeleopFrontend dependencies..."
cd EasyTeleopFrontend
# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo "Installing pnpm..."
    npm install -g pnpm
fi

pnpm install --frozen-lockfile
if [ $? -ne 0 ]; then
    echo "Error installing Frontend dependencies"
    cd ..
    exit 1
fi
cd ..

echo ""
echo "Deployment completed successfully!"
echo ""
echo "To start the services, run:"
echo "  - ./start-node.sh for Node service"
echo "  - ./start-backend.sh for Backend service"
echo "  - ./start-frontend.sh for Frontend service"
echo ""