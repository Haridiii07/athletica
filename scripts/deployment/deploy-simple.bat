@echo off
echo ========================================
echo    Athletica - Simple Deployment
echo ========================================
echo.

echo [1/3] Building your app...
flutter clean
flutter pub get
flutter build web --release

echo.
echo [2/3] Checking build...
if exist build\web (
    echo ✓ SUCCESS! Your app is built and ready!
    echo ✓ Files are in: build\web\
    echo.
    echo [3/3] Next steps:
    echo.
    echo OPTION 1 - Netlify (Easiest):
    echo 1. Go to https://netlify.com
    echo 2. Sign up with GitHub
    echo 3. Click "New site from Git"
    echo 4. Select: Haridiii07/athletica
    echo 5. Set Build: flutter build web --release
    echo 6. Set Publish: build/web
    echo 7. Click Deploy!
    echo.
    echo OPTION 2 - Vercel:
    echo 1. Go to https://vercel.com
    echo 2. Sign up with GitHub
    echo 3. Import: Haridiii07/athletica
    echo 4. Set Build: flutter build web --release
    echo 5. Set Output: build/web
    echo 6. Click Deploy!
    echo.
    echo Your app will be live in 2-3 minutes!
) else (
    echo ✗ Build failed! Please check for errors.
)

echo.
pause
