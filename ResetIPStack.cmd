@ECHO OFF
:START_ADMIN_CHECK
CLS
REM REVISED 9-28-2020
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
cls
echo.
echo.This may disconnect your network connection.
echo.
echo.Are you sure you want to proceed?
echo.
echo.1 - Yes
echo.2 - No ^(Default^)
echo.
echo.
choice /c 12 /d 2 /n /t 30 /m Answer: 
if %errorlevel% equ 1 GOTO MAKESCRIPT
if %errorlevel% equ 2 (
set logname=nolog
GOTO EOF
)

:MAKESCRIPT
(
echo.@echo off
echo.netsh winsock reset
echo.netsh int ip reset
echo.netsh interface ipv4 reset
echo.netsh interface ipv6 reset
echo.netsh interface tcp reset
echo.ipconfig /flushdns
echo.nbtstat -R
echo.nbtstat -RR
echo.netsh advfirewall reset
echo.if exist "%PROGRAMFILES(X86)%\Quarantine\Amazon_Default_Firewall_Policy.wfw" netsh advfirewall import "%PROGRAMFILES(X86)%\Quarantine\Amazon_Default_Firewall_Policy.wfw"
echo.exit
) > %temp%\resetstack.cmd

if not exist %temp%\resetstack.cmd GOTO MANUALLY
:RUNSCRIPT
cls
echo.
echo.Launching script to reset the IP Stack for this computer..
echo.
echo.
%temp%\resetstack.cmd
timeout /t 3 > NUL
GOTO EOF

:MANUALLY
cls
echo.
echo.That didn't seem to work.
echo.
echo.Here are the commands to run manually on this machine.
echo.Make sure you run them in an Administrator CMD Window.
echo.
echo.
echo.netsh winsock reset
echo.netsh int ip reset
echo.netsh interface ipv4 reset
echo.netsh interface ipv6 reset
echo.netsh interface tcp reset
echo.ipconfig /flushdns
echo.nbtstat -R
echo.nbtstat -RR
echo.netsh advfirewall reset
pause
SET LOGLNAME=NOLOG

:EOF
CLS
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=RESETSTACK
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------
del /q %temp%\resetstack.cmd
:EOFF
exit