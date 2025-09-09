@echo off
echo =====================
echo Quick Flutter Fix
echo =====================
echo.

echo Enabling Windows desktop support...
flutter config --enable-windows-desktop

echo.
echo Cleaning Flutter cache...
flutter clean

echo.
echo Getting Flutter packages...
flutter pub get

echo.
echo Refreshing dependencies...
flutter pub deps

echo.
echo Checking Flutter status...
flutter doctor

echo.
echo =====================
echo Quick fix completed!
echo =====================
echo.
echo If you still see RED errors:
echo 1. Close Cursor completely
echo 2. Restart Cursor
echo 3. Wait 30 seconds for analysis server
echo.
pause
