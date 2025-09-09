@echo off
echo Building Flutter web app for GitHub Pages...

echo Cleaning...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building web app...
flutter build web --release

echo Build complete! Files are in build/web/
echo.
echo To deploy to GitHub Pages:
echo 1. Go to https://github.com/Haridiii07/athletica/settings/pages
echo 2. Set Source to "Deploy from a branch"
echo 3. Set Branch to "main" and Folder to "/ (root)"
echo 4. Or use the GitHub Actions workflow
echo.
pause
