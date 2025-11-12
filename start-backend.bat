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
start "Backend Main" python backend.py

timeout /t 2

echo Starting MQTT sync service...
start "Backend MQTT" python run_mqtt_sync.py

cd ..

echo Backend services started.
echo Press any key to exit this window (services will continue running)
pause >nul