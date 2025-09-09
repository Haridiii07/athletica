@echo off
echo ========================================
echo    Athletica - Quick Deployment
echo ========================================
echo.

echo [1/4] Building Flutter web app...
flutter clean
flutter pub get
flutter build web --release

echo.
echo [2/4] Checking build...
if exist build\web (
    echo ✓ Build successful!
) else (
    echo ✗ Build failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Creating deployment package...
if not exist deploy mkdir deploy
xcopy /E /I /Y build\web deploy\

echo.
echo [4/4] Deployment Options:
echo.
echo OPTION 1 - GitHub Pages (Manual):
echo 1. Go to https://github.com/Haridiii07/athletica/settings/pages
echo 2. Set Source to "Deploy from a branch"
echo 3. Set Branch to "main" and Folder to "/ (root)"
echo 4. Upload the contents of the 'deploy' folder to the root
echo.
echo OPTION 2 - Netlify (Recommended):
echo 1. Go to https://netlify.com
echo 2. Drag and drop the 'deploy' folder
echo 3. Your app will be live in 30 seconds!
echo.
echo OPTION 3 - Vercel:
echo 1. Go to https://vercel.com
echo 2. Import your GitHub repository
echo 3. Set Build Command: flutter build web --release
echo 4. Set Output Directory: build/web
echo.
echo Your app files are ready in the 'deploy' folder!
echo.
pause
