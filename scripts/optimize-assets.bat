@echo off
echo ========================================
echo    Athletica - Asset Optimization
echo ========================================
echo.

echo [1/5] Checking for image optimization tools...
where magick >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️  ImageMagick not found. Install from: https://imagemagick.org/
    echo    Or use online tools: https://squoosh.app/ or https://tinypng.com/
) else (
    echo ✅ ImageMagick found
)

echo.
echo [2/5] Analyzing current assets...

if exist "assets\images" (
    echo 📁 Images directory found
    for /r assets\images %%f in (*.png *.jpg *.jpeg *.gif) do (
        echo   Found: %%~nxf
    )
) else (
    echo 📁 No images directory found
)

if exist "assets\fonts" (
    echo 📁 Fonts directory found
    for /r assets\fonts %%f in (*.ttf *.woff *.woff2) do (
        echo   Found: %%~nxf
    )
) else (
    echo 📁 No fonts directory found
)

echo.
echo [3/5] Font optimization recommendations...

echo 🎯 Google Fonts Optimization:
echo   - Use Arabic subset: &subset=arabic
echo   - Only required weights: wght@400;700
echo   - Add display=swap for better performance
echo   - Current URL: https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&subset=arabic&display=swap

echo.
echo [4/5] Image optimization recommendations...

echo 🎯 Image Optimization:
echo   - Convert to WebP format (25-50%% smaller)
echo   - Compress with TinyPNG or Squoosh
echo   - Use appropriate sizes (max 1920x1080)
echo   - Implement lazy loading for large images

echo.
echo [5/5] Asset optimization complete!

echo.
echo 💡 Next steps:
echo   1. Optimize images using online tools
echo   2. Convert to WebP format when possible
echo   3. Use font subsets for Google Fonts
echo   4. Implement lazy loading for images
echo   5. Test performance improvements

echo.
pause
