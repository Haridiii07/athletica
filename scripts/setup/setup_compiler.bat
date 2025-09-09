@echo off
echo ================================
echo Athletica C++ Compiler Setup
echo ================================
echo.

:: Check if running as admin
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERROR: This script must be run as Administrator!
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

echo [1/5] Checking current environment...
where cl >nul 2>&1
if %errorLevel% EQU 0 (
    echo ✓ C++ Compiler already found!
) else (
    echo ✗ C++ Compiler not found
)

where cmake >nul 2>&1
if %errorLevel% EQU 0 (
    echo ✓ CMake already found!
) else (
    echo ✗ CMake not found
)

echo.
echo [2/5] Installing Visual Studio Build Tools via winget...
winget install Microsoft.VisualStudio.2022.BuildTools --accept-package-agreements --accept-source-agreements

echo.
echo [3/5] Installing individual components if needed...
winget install Microsoft.VisualCpp.Redistributable.2022 --accept-package-agreements --accept-source-agreements
winget install Kitware.CMake --accept-package-agreements --accept-source-agreements

echo.
echo [4/5] Setting up environment variables...
:: Add VS Build Tools to PATH
set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC"
for /d %%i in ("%VS_PATH%\*") do set "LATEST_MSVC=%%i"
set "COMPILER_PATH=%LATEST_MSVC%\bin\Hostx64\x64"
setx PATH "%PATH%;%COMPILER_PATH%" /M

:: Add CMake to PATH
set "CMAKE_PATH=C:\Program Files\CMake\bin"
setx PATH "%PATH%;%CMAKE_PATH%" /M

echo.
echo [5/5] Verifying installation...
timeout /t 3 /nobreak >nul
"%COMPILER_PATH%\cl.exe" >nul 2>&1
if %errorLevel% LEQ 1 (
    echo ✓ C++ Compiler installed successfully!
) else (
    echo ✗ C++ Compiler installation failed
)

cmake --version >nul 2>&1
if %errorLevel% EQU 0 (
    echo ✓ CMake installed successfully!
) else (
    echo ✗ CMake installation failed
)

echo.
echo ================================
echo Setup Complete!
echo ================================
echo Please restart your computer for changes to take effect.
echo Then run: flutter doctor -v
echo.
pause
