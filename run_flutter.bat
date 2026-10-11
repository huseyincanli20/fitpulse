@echo off
title FitPulse Flutter Uygulamasi (Canli)
echo ========================================================
echo    FitPulse Flutter Canli Web Uygulamasi Baslatiliyor...
echo ========================================================
set "PATH=C:\Users\husey\development\flutter\bin;C:\Users\husey\development\git\cmd;%PATH%"
cd /d "%~dp0"

powershell -ExecutionPolicy Bypass -File "%~dp0serve_flutter.ps1" -Port 5050
pause
