@echo off
title FitPulse Gelistirici Modu (Hot Reload)
echo ========================================================
echo    FitPulse Flutter Gelistirici Modu (Hot Reload)...
echo    Kod degisikliklerini aninda gormek icin 'r' basin.
echo ========================================================
set "PATH=C:\Users\husey\development\flutter\bin;C:\Users\husey\development\git\cmd;%PATH%"
cd /d "%~dp0"
flutter run -d chrome
pause
