@echo off
setlocal

echo Starting EasyTeleop Backend Service...
echo ======================================

if not exist "EasyTeleop-Backend-Python" (
    echo Error: EasyTeleop-Backend-Python directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

cd EasyTeleop-Backend-Python

echo Starting main backend service...
uv run backend.py

cd ..

echo Backend service stopped.
pause