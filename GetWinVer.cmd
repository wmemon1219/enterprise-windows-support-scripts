@echo off
cls
title Windows Version Getter

for /f "tokens=3" %%I in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseID') do set version=%%I
MODE CON: COLS=52 LINES=8
echo.
echo.
echo. You have Windows Version %version%
echo.
echo.
echo.
timeout /t 30
echo.
exit