@echo off
setlocal

echo Starting EasyTeleop Frontend Service...
echo =======================================

if not exist "EasyTeleopFrontend" (
    echo Error: EasyTeleopFrontend directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

cd EasyTeleopFrontend

echo Starting frontend development server...
npm run dev

cd ..

echo Frontend service stopped.
pause