@echo off
REM This script was created by David Burton (daviburt)
title 3.5 .NET Framework Installer
cls
if /i %computername%==Toolshed GOTO EOFF
reg query "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP" | findstr /i 3.5 > NUL
if %errorlevel% equ 0 (
	if exist %temp%\patchmypc.txt GOTO EOFF
    if exist %TEMP%\AMAZONIFY\FROMUPDATER EXIT
	cls
    echo.
    echo.The 3.5 .NET Framework is already installed.
    echo.
    echo.Quitting.
    echo.
    echo.
    timeout /t 10 > NUL
    GOTO EOF
) 

:START_ADMIN_CHECK
CLS
REM REVISED 5-30-18
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
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
net localgroup administrators fs-toolshed-it /add > NUL


:--------------------------------------
if exist \\toolshed.corp.amazon.com\share\Imaging\Windows\WIN10_Upgrade\Files\Files\1809\sources\sxs set netdir=\\toolshed.corp.amazon.com\share\Imaging\Windows\WIN10_Upgrade\Files\Files\1809\sources\sxs
if exist \\ant\dept-na\SFO12_Toolshed\Windows10Upgrade\Files\1809\sources\sxs set netdir=\\ant\dept-na\SFO12_Toolshed\Windows10Upgrade\Files\1809\sources\sxs
:--------------------------------------
if [%netdir%]==[] (
echo.
echo.I'm unable to locate the source files needed to run this script..
echo.
echo.Quitting..
echo.
timeout /t 15 > NUL
GOTO EOF
)

:INSTALL
echo.
echo.Attempting to install .NET Framework
start /wait DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /NoRestart /Source:%netdir%
if exist %TEMP%\AMAZONIFY\FROMUPDATER EXIT

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=frameworkinstall
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
