@echo off
title Fix Blank Icons in Your System Tray
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


cls
set regPath=HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify
set regKey1=IconStreams
set regKey2=PastIconsStream
set choice=Bad-Response

echo The Explorer process must be killed to reset the Notification Area Icons Cache. 
echo.
echo Please SAVE ALL OPEN WORK before continuing
echo.
timeout /t 10 /nobreak

echo.
taskkill /IM explorer.exe /F
echo.
FOR /F "tokens=*" %%a in ('Reg Query "%regpath%" /v %regkey1% ^| find /i "%regkey1%"') do goto iconstreams
echo Registry key "IconStreams" already deleted.
echo.

:verify-PastIconsStream
FOR /F "tokens=*" %%a in ('Reg Query "%regpath%" /v %regkey2% ^| find /i "%regkey2%"') do goto PastIconsStream
echo Registry key "PastIconsStream" already deleted.
echo.
goto confirm-restart

:iconstreams
reg delete "%regpath%" /f /v "%regkey1%"
goto verify-PastIconsStream

:PastIconsStream
reg delete "%regpath%" /f /v "%regkey2%"
start "" explorer.exe

:confirm-restart
echo.
echo.
echo Windows must be restarted to finish resetting the Notification Area Icons. 
echo.

:wrong 
set /p choice=Restart now? (Y/N) and press Enter:
If /i %choice% == y goto Yes
If /i %choice% == n goto No
set choice=Bad-Response
goto wrong

:Yes
shutdown /R /f /t 00
exit

:No
echo.
echo Restart aborted. Please remember to restart the computer later.
echo.
echo You can now close this command prompt window.
timeout /t 15 /nobreak
explorer.exe

:EOF
CLS
:-------------------------------------
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=FixBlankIcons
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------
set checkdir=
:EOFF
exit
