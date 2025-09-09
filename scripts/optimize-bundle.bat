@echo off
echo ========================================
echo    Athletica - Bundle Size Optimization
echo ========================================
echo.

echo [1/6] Cleaning previous builds...
flutter clean

echo.
echo [2/6] Getting dependencies...
flutter pub get

echo.
echo [3/6] Analyzing code...
flutter analyze

echo.
echo [4/6] Building web with size analysis...
flutter build web --release --analyze-size --web-renderer html --base-href /athletica/

echo.
echo [5/6] Checking bundle size...
if exist build\web (
    echo ✅ Build successful!
    echo.
    echo 📊 Bundle Analysis:
    echo ===================
    
    echo.
    echo 📁 Main Files:
    for %%f in (build\web\*.js) do (
        echo   %%~nxf: %%~zf bytes
    )
    
    echo.
    echo 📁 Assets:
    for /r build\web\assets %%f in (*) do (
        echo   %%~nxf: %%~zf bytes
    )
    
    echo.
    echo 📁 Total Size:
    for /f %%i in ('dir build\web /s /-c ^| find "File(s)"') do echo   %%i bytes
    
    echo.
    echo 🎯 Optimization Recommendations:
    echo   - Check build\web\flutter_service_worker.js for large chunks
    echo   - Optimize images in assets\images\
    echo   - Consider removing unused dependencies
    echo   - Use font subsets for Google Fonts
    
) else (
    echo ❌ Build failed! Check for errors above.
)

echo.
echo [6/6] Bundle optimization complete!
echo.
pause
