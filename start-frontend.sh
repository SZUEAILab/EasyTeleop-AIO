#!/bin/bash

echo "Starting EasyTeleop Frontend Service..."
echo "======================================="

if [ ! -d "EasyTeleopFrontend" ]; then
    echo "Error: EasyTeleopFrontend directory not found!"
    echo "Please run this script from the EasyTeleop-AIO root directory."
    exit 1
fi

cd EasyTeleopFrontend

echo "Starting frontend development server..."
npm run dev

cd ..

echo "Frontend service stopped."