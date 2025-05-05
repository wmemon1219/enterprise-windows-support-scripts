@ECHO OFF
:START_ADMIN_CHECK
CLS
title Wifi toggler

:PING
cls
echo.
echo.Checking network..
echo.
ping google.com -n 1 > NUL
if %errorlevel% equ 1 GOTO START
:PING2
cls
echo.
echo.I can access the internet. Are you sure you want to continue?
echo.
echo.1 - Yes
echo.2 - No ^(Default^)
echo.
echo.
choice /c 12 /d 2 /n /t 15 /m Answer: 
if %errorlevel% equ 1 (
set confirm=yes
GOTO START
)
if %errorlevel% equ 2 (
set loganme=skiplog
goto eof
)

:START
REM REVISED 9-9-2020
REM SETTING SOURCE DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
if exist \\toolshed.corp.amazon.com\share\Windows set workdir=\\toolshed.corp.amazon.com\share
REM FPH
:--------------------------------------

REM IF THE WORKDIR VARIABLE IS BLANK THIS WILL BYPASS GIVING THE WARNING AGAIN IF ITS ALREADY WARNED THE PERSON RUNNING IT

if exist %temp%\checked-admin goto CHECK_IF_RUN_AS_ADMIN


:CHECK_IF_RUN_AS_ADMIN
REM CHECKING IF THE SCRIPT IS RUNNING AS AN ADMINISTRATOR
FOR /f "usebackq" %%f IN (`whoami /priv`) DO IF "%%f"=="SeTakeOwnershipPrivilege" GOTO RUNNING_AS_ADMIN

:ELEVATE
REM CHECKING IF THE CURRENT ACCOUNT HAS ADMIN RIGHTS TO SKIP ELEVATION
net localgroup administrators | findstr /i %username% > NUL
if %errorlevel% equ 1 (
SET LOGNAME=SKIPLOG
if exist "%workdir%\Windows\Scripts\elevate.cmd" start /wait "" "%workdir%\Windows\Scripts\elevate.cmd"
SET LOGNAME=
)

:ADMINPROMPT
ECHO CreateObject("Shell.Application").ShellExecute Chr(34) ^& "%WINDIR%\System32\cmd.exe" ^& Chr(34), "/K " ^& Chr(34) ^& "%~dpfx0 %*" ^& Chr(34), "", "runas", 1 >"%TEMP%\RunAs.vbs"
WScript.exe "%TEMP%\RunAs.vbs"
GOTO EOFF

:RUNNING_AS_ADMIN
REM THIS IS A TEMPORARY ADD OF THAT GROUP TO ADMIN AS A JUST IN CASE SOMETHING GOES WRONG AND ADMIN IS LOST, AT LEAST ANYONE IN THIS GROUP WILL HAVE IT UNTIL THEY'RE DONE
net localgroup administrators | findstr /i toolshed > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /add > NUL

if not "%confirm%"=="yes" (
ping google.com > NUL
if %errorlevel% equ 0 goto ping2
)
cls
echo.
echo.Disabling Wi-Fi
echo.
start /min "" netsh interface set interface Wi-Fi disable
net stop "WLAN AutoConfig"
timeout /t 5
cls
echo.
echo.Enabling Wi-Fi
echo.
netsh interface set interface Wi-Fi enable
net start "WLAN AutoConfig"
timeout /t 7
GOTO EOF

:EOF
CLS
if exist %localappdata%\temp\fromupdater EXIT
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=WIFITOGGLE
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
