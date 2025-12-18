@echo off
setlocal enabledelayedexpansion

rem Export EasyTeleop images to offline tarballs (amd64/arm64).
rem Usage:
rem   export-tars.bat [--image-repo REPO] [--tag TAG] [--out-dir DIR] [--arch amd64|arm64|both] [--skip-build] [--skip-pull] [--keep-images]
rem Defaults: REPO=easyteleop TAG=latest DIR=dist ARCH=both

set "IMAGE_REPO=easyteleop"
set "TAG=latest"
set "OUT_DIR=dist"
set "ARCH=both"
set "SKIP_BUILD=0"
set "SKIP_PULL=0"
set "KEEP_IMAGES=0"

:parse
if "%~1"=="" goto parsed
if /I "%~1"=="-r"          (set "IMAGE_REPO=%~2" & shift & shift & goto parse)
if /I "%~1"=="--image-repo" (set "IMAGE_REPO=%~2" & shift & shift & goto parse)
if /I "%~1"=="-t"      (set "TAG=%~2" & shift & shift & goto parse)
if /I "%~1"=="--tag"   (set "TAG=%~2" & shift & shift & goto parse)
if /I "%~1"=="-o"          (set "OUT_DIR=%~2" & shift & shift & goto parse)
if /I "%~1"=="--out-dir"   (set "OUT_DIR=%~2" & shift & shift & goto parse)
if /I "%~1"=="-a"      (set "ARCH=%~2" & shift & shift & goto parse)
if /I "%~1"=="--arch"  (set "ARCH=%~2" & shift & shift & goto parse)
if /I "%~1"=="--skip-build" (set "SKIP_BUILD=1" & shift & goto parse)
if /I "%~1"=="--skip-pull"  (set "SKIP_PULL=1" & shift & goto parse)
if /I "%~1"=="--keep-images" (set "KEEP_IMAGES=1" & shift & goto parse)
if /I "%~1"=="-h" goto help
if /I "%~1"=="--help" goto help

echo Unknown arg: %~1
goto help

:help
echo Export EasyTeleop images to offline tarballs (amd64/arm64)
echo.
echo Usage:
echo   export-tars.bat [--image-repo REPO] [--tag TAG] [--out-dir DIR] [--arch amd64^|arm64^|both] [--skip-build] [--skip-pull] [--keep-images]
echo.
echo Examples:
echo   export-tars.bat --image-repo easyteleop --tag latest --out-dir dist --arch both
exit /b 2

:parsed
where docker >nul 2>&1
if errorlevel 1 (
  echo docker not found in PATH
  exit /b 1
)

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

if /I "%ARCH%"=="amd64" (
  call :export_one_arch amd64 || exit /b 1
  exit /b 0
)
if /I "%ARCH%"=="arm64" (
  call :export_one_arch arm64 || exit /b 1
  exit /b 0
)
if /I "%ARCH%"=="both" (
  call :export_one_arch amd64 || exit /b 1
  call :export_one_arch arm64 || exit /b 1
  exit /b 0
)

echo Invalid --arch: %ARCH%  (expected amd64^|arm64^|both)
exit /b 2

:export_one_arch
set "ONEARCH=%~1"

if "%SKIP_BUILD%"=="0" (
  set "IMAGE_REPO=%IMAGE_REPO%"
  set "TAG=%TAG%"
  docker buildx bake -f docker-bake.hcl tar_%ONEARCH% --load
  if errorlevel 1 exit /b 1
)

if "%SKIP_PULL%"=="0" (
  docker pull --platform linux/%ONEARCH% nginx:1.25-alpine
  if errorlevel 1 exit /b 1

  docker pull --platform linux/%ONEARCH% emqx/emqx:5.3.1
  if errorlevel 1 exit /b 1

)

set "REPO_SLUG=%IMAGE_REPO:/=_%"
set "REPO_SLUG=%REPO_SLUG:\=_%"
set "REPO_SLUG=%REPO_SLUG::=_%"

set "OUT_TAR=%OUT_DIR%\%REPO_SLUG%-%TAG%-%ONEARCH%.tar"

docker save -o "%OUT_TAR%" ^
  "%IMAGE_REPO%/backend:%TAG%" ^
  "%IMAGE_REPO%/node:%TAG%" ^
  "%IMAGE_REPO%/frontend:%TAG%" ^
  "%IMAGE_REPO%/hdf5:%TAG%" ^
  "nginx:1.25-alpine" ^
  "emqx/emqx:5.3.1"
if errorlevel 1 exit /b 1

echo Wrote: %OUT_TAR%

if "%KEEP_IMAGES%"=="0" (
  rem Best-effort cleanup; ignore failures (e.g. images in use).
  docker image rm -f ^
    "%IMAGE_REPO%/backend:%TAG%" ^
    "%IMAGE_REPO%/node:%TAG%" ^
    "%IMAGE_REPO%/frontend:%TAG%" ^
    "%IMAGE_REPO%/hdf5:%TAG%" ^
    "nginx:1.25-alpine" ^
    "emqx/emqx:5.3.1" >nul 2>&1
)
exit /b 0
