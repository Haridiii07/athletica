@echo off
echo Building Athletica Frontend for GitHub Pages...

REM Clean and get dependencies
flutter clean
flutter pub get

REM Build for web (using optimized workflow version)
flutter build web --release --base-href /athletica/ --target lib/main_workflow_optimized.dart

REM Copy to docs folder for GitHub Pages
if exist docs\web rmdir /s /q docs\web
mkdir docs\web
xcopy /e /i build\web docs\web

echo Frontend built successfully!
echo Files are in docs/web folder
echo Push to GitHub to deploy to GitHub Pages
pause
