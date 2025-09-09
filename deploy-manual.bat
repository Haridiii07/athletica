@echo off
echo ========================================
echo    Athletica - Manual GitHub Pages Deployment
echo ========================================
echo.

echo [1/5] Cleaning previous build...
flutter clean

echo.
echo [2/5] Getting dependencies...
flutter pub get

echo.
echo [3/5] Building web app...
flutter build web --release

echo.
echo [4/5] Preparing deployment...
if exist build\web (
    echo ✓ Web build successful!
    echo ✓ Files ready in build\web\
) else (
    echo ✗ Build failed! Please check for errors.
    pause
    exit /b 1
)

echo.
echo [5/5] Deployment Instructions:
echo.
echo To deploy manually:
echo 1. Go to https://github.com/Haridiii07/athletica/settings/pages
echo 2. Set Source to "Deploy from a branch"
echo 3. Set Branch to "main" and Folder to "/ (root)"
echo 4. Or use the GitHub Actions workflow
echo.
echo Alternative: Use Netlify or Vercel for easier deployment
echo - Netlify: https://netlify.com (connect GitHub repo)
echo - Vercel: https://vercel.com (connect GitHub repo)
echo.
echo Your app will be available at: https://haridiii07.github.io/athletica/
echo.
pause
