# Athletica C++ Compiler Setup (PowerShell)
# Run as Administrator: Right-click -> Run with PowerShell

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Athletica C++ Compiler Setup" -ForegroundColor Cyan  
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click this file and select 'Run with PowerShell' as Administrator" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[1/5] Checking current environment..." -ForegroundColor Yellow
try {
    & cl 2>&1 | Out-Null
    Write-Host "✓ C++ Compiler already found!" -ForegroundColor Green
} catch {
    Write-Host "✗ C++ Compiler not found" -ForegroundColor Red
}

try {
    & cmake --version 2>&1 | Out-Null
    Write-Host "✓ CMake already found!" -ForegroundColor Green
} catch {
    Write-Host "✗ CMake not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "[2/5] Installing Visual Studio Build Tools..." -ForegroundColor Yellow
try {
    & winget install Microsoft.VisualStudio.2022.BuildTools --accept-package-agreements --accept-source-agreements
    Write-Host "✓ Build Tools installation completed" -ForegroundColor Green
} catch {
    Write-Host "⚠ Build Tools installation may have failed - continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[3/5] Installing supporting components..." -ForegroundColor Yellow
try {
    & winget install Microsoft.VisualCpp.Redistributable.2022 --accept-package-agreements --accept-source-agreements
    & winget install Kitware.CMake --accept-package-agreements --accept-source-agreements
    Write-Host "✓ Supporting components installed" -ForegroundColor Green
} catch {
    Write-Host "⚠ Some components may have failed - continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[4/5] Setting up environment variables..." -ForegroundColor Yellow

# Find the latest MSVC version
$VSPath = "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC"
if (Test-Path $VSPath) {
    $LatestMSVC = Get-ChildItem $VSPath | Sort-Object Name -Descending | Select-Object -First 1
    $CompilerPath = "$($LatestMSVC.FullName)\bin\Hostx64\x64"
    
    # Add to system PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -notlike "*$CompilerPath*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$CompilerPath", "Machine")
        Write-Host "✓ Added compiler to PATH" -ForegroundColor Green
    }
} else {
    Write-Host "⚠ Visual Studio Build Tools path not found" -ForegroundColor Yellow
}

# Add CMake to PATH
$CMakePath = "C:\Program Files\CMake\bin"
if (Test-Path $CMakePath) {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -notlike "*$CMakePath*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$CMakePath", "Machine")
        Write-Host "✓ Added CMake to PATH" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "[5/5] Refreshing environment..." -ForegroundColor Yellow
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your computer" -ForegroundColor White
Write-Host "2. Open new terminal in your Flutter project" -ForegroundColor White  
Write-Host "3. Run: flutter doctor -v" -ForegroundColor White
Write-Host "4. Run: flutter clean && flutter pub get" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to continue"
