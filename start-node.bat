@echo off
setlocal

echo Starting EasyTeleop Node Service...
echo ===================================

if not exist "EasyTeleop-Node" (
    echo Error: EasyTeleop-Node directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

cd EasyTeleop-Node
echo Running Node service...
uv run node.py
cd ..

echo Node service stopped.
pause