@echo off
title SFC and DISM System Maintenance - daviburt
:START_ADMIN_CHECK
CLS
REM REVISED 7-19-18
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist \\toolshed.corp.amazon.com\share\Windows set workdir=\\toolshed.corp.amazon.com\share
REM FPH
:--------------------------------------

REM IF THE WORKDIR VARIABLE IS BLANK THIS WILL BYPASS GIVING THE WARNING AGAIN IF ITS ALREADY WARNED THE PERSON RUNNING IT

if exist %temp%\checked-admin goto CHECK_IF_RUN_AS_ADMIN

:NO_WORK_DIR
REM OUTPUT IF THE WORKDIR VARIABLE CANT BE SET
if [%workdir%]==[] (
echo.I'm unable to reach the directory possibly needed for this script to run properly.
echo.
echo.Please e-mail toolshed-feedback^@amazon.com if you believe this to be incorrect.
echo.
timeout /t 10
echo 1 > %temp%\checked-admin
)

:CHECK_IF_RUN_AS_ADMIN
REM CHECKING IF THE SCRIPT IS RUNNING AS AN ADMINISTRATOR
FOR /f "usebackq" %%f IN (`whoami /priv`) DO IF "%%f"=="SeTakeOwnershipPrivilege" GOTO RUNNING_AS_ADMIN

:ELEVATE
REM CHECKING IF THE CURRENT ACCOUNT HAS ADMIN RIGHTS TO SKIP ELEVATION
net localgroup administrators | findstr /i %username% > NUL
if %errorlevel% equ 1 (
SET LOGNAME=SKIPLOG
start /wait "" "%workdir%\Windows\Scripts\elevate.cmd"
SET LOGNAME=
)

:ADMINPROMPT
ECHO CreateObject("Shell.Application").ShellExecute Chr(34) ^& "%WINDIR%\System32\cmd.exe" ^& Chr(34), "/K " ^& Chr(34) ^& "%~dpfx0 %*" ^& Chr(34), "", "runas", 1 >"%TEMP%\RunAs.vbs"
WScript.exe "%TEMP%\RunAs.vbs"
GOTO EOFF

:RUNNING_AS_ADMIN
if /i "%BOTH%"=="" cls
echo.
echo.1 - SFC Scan
echo.2 - DISM ^/online ^/cleanup-image ^/restorehealth
echo.
echo.3 - Both 1 ^& 2
echo.
echo.4 - Quit
echo.
echo.
CHOICE /C:1234 /N /D 4 /T 60 /M "Your Answer: "
if %errorlevel% equ 1 GOTO SFC
if %errorlevel% equ 2 GOTO DISM
if %errorlevel% equ 3 SET BOTH=YES
if %errorlevel% equ 4 (
set logname=nolog
GOTO EOF
)

:SFC
@echo on
sfc /scannow
@echo off
if /i "%BOTH%"=="YES" GOTO DISM
pause
GOTO RUNNING_AS_ADMIN

:DISM
@echo on
dism /online /cleanup-image /restorehealth
@echo off
pause
GOTO RUNNING_AS_ADMIN


:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=SFC_DISM
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)

:EOFF
exit
