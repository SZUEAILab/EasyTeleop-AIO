@echo off
setlocal enabledelayedexpansion

echo Installing and starting EMQX MQTT server...

rem Check if Docker is installed
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker is not installed or not in PATH.
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Pulling EMQX Enterprise Docker image...
docker pull emqx/emqx-enterprise:6.0.1
if %errorlevel% neq 0 (
    echo Error: Failed to pull EMQX Docker image.
    pause
    exit /b 1
)

echo Starting EMQX Enterprise container...
docker run -d ^
  --name emqx-enterprise ^
  -p 1883:1883 ^
  -p 8083:8083 ^
  -p 8084:8084 ^
  -p 8883:8883 ^
  -p 18083:18083 ^
  emqx/emqx-enterprise:6.0.1

if %errorlevel% neq 0 (
    echo Error: Failed to start EMQX container.
    pause
    exit /b 1
)

echo EMQX MQTT server successfully started!
echo Container name: emqx-enterprise
echo Ports mapped:
echo  - MQTT: 1883
echo  - WebSocket: 8083
echo  - SSL WebSocket: 8084
echo  - MQTT SSL: 8883
echo  - Dashboard: 18083
echo.
echo You can access the dashboard at http://localhost:18083
pause