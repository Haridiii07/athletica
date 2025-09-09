@echo off
echo ========================================
echo    Athletica - Dependency Cleanup
echo ========================================
echo.

echo [1/5] Analyzing current dependencies...
powershell -ExecutionPolicy Bypass -File "scripts\analyze-dependencies.ps1"

echo.
echo [2/5] Analyzing imports...
powershell -ExecutionPolicy Bypass -File "scripts\optimize-imports.ps1"

echo.
echo [3/5] Cleaning Flutter cache...
flutter clean

echo.
echo [4/5] Getting optimized dependencies...
flutter pub get

echo.
echo [5/5] Running dependency analysis...
flutter pub deps

echo.
echo ✅ Dependency cleanup complete!
echo.
echo 💡 Next steps:
echo   1. Review the analysis results above
echo   2. Remove any remaining unused dependencies
echo   3. Test the application thoroughly
echo   4. Run bundle analysis to verify improvements
echo.
pause
