@echo off
@REM setlocal enabledelayedexpansion

echo EasyTeleop AIO Deployment Script for Windows
echo =============================================

:: Sync submodules
echo [0/3] Syncing submodules...
git submodule update --init --recursive
if %errorlevel% neq 0 (
    echo Error syncing submodules
    pause
    exit /b 1
)

:: Check if running from the correct directory
if not exist "EasyTeleop-Node" (
    echo Error: EasyTeleop-Node directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

if not exist "EasyTeleop-Backend-Python" (
    echo Error: EasyTeleop-Backend-Python directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

if not exist "EasyTeleopFrontend" (
    echo Error: EasyTeleopFrontend directory not found!
    echo Please run this script from the EasyTeleop-AIO root directory.
    pause
    exit /b 1
)

echo [1/3] Installing EasyTeleop-Node dependencies...
cd EasyTeleop-Node
if not exist "uv.lock" (
    echo Warning: uv.lock not found. Creating new lock file.
)
:: Install uv if not present
python -c "import uv" >nul 2>&1 || pip install uv
uv sync
if %errorlevel% neq 0 (
    echo Error installing Node dependencies
    cd ..
    pause
    exit /b 1
)
cd ..

echo [2/3] Installing EasyTeleop-Backend-Python dependencies...
cd EasyTeleop-Backend-Python
uv sync
if %errorlevel% neq 0 (
    echo Error installing Backend dependencies
    cd ..
    exit /b 1
)
cd ..

echo [3/3] Installing EasyTeleopFrontend dependencies...
cd EasyTeleopFrontend
:: Check if pnpm is installed
call pnpm --version >nul 2>&1 || (
    echo Installing pnpm...
    call npm install -g pnpm
)
call pnpm install --frozen-lockfile
if %errorlevel% neq 0 (
    echo Error installing Frontend dependencies
    cd ..
    pause
    exit /b 1
)
cd ..

echo.
echo Deployment completed successfully!
echo.
echo To start the services, run:
echo   - start-node.bat for Node service
echo   - start-backend.bat for Backend service
echo   - start-frontend.bat for Frontend service
echo.

pause