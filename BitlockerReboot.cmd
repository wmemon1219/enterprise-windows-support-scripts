@echo off
title Pause Bitlocker Until Rebooted 

:START_ADMIN_CHECK
CLS
REM REVISED 4-23-2020
REM SETTING SOURCE DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist \\toolshed\Windows set workdir=\\TOOLSHED
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
REM THIS IS A TEMPORARY ADD OF THAT GROUP TO ADMIN AS A JUST IN CASE SOMETHING GOES WRONG AND ADMIN IS LOST, AT LEAST ANYONE IN THIS GROUP WILL HAVE IT UNTIL THEY'RE DONE
net localgroup administrators | findstr /i toolshed > NUL
if %errorlevel% equ 1 net localgroup administrators fs-toolshed-it /add > NUL

:START
cls

manage-bde c: -status | findstr /c:"Conversion Status" | findstr /c:"Fully Decrypted"
if %errorlevel% equ 1 GOTO BLREBOOT
cls
echo.
echo.Bitlocker isn't enabled on this system..
echo.
echo.Did you want to open the Bitlocker Management Script?
echo.
echo.1 - Yes
echo.2 - No and Quit
echo.
choice /c 12 /d 2 /n /t 60 /m Answer: 
if %errorlevel% equ 1 "%workdir%\Windows\Scripts\ManageBitlocker.cmd"
if %errorlevel% equ 2 GOTO EOFF

:BLREBOOT
start /min "" manage-bde c: -pause
start /min "" manage-bde -protectors -disable c:
start /min "" tskill acme*
start /min "" powershell Suspend-BitLocker c:
(
echo.manage-bde -protectors -enable c^:
echo.manage-bde c: -resume
echo.shutdown -a
echo.del /q c:^\utilities^\enablebl.bat
)  > c:\utilities\enablebl.bat
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v Data /t Reg_SZ /d "c:\utilities\enablebl.bat" /f
start "" shutdown -r

set to=55
:PREREBOOT
cls
echo.1 - Cancel the Reboot
if not "%to%"=="8" echo.2 - Reboot Now
echo.
echo.
CHOICE /c 123 /n /d 3 /t %to% /m Answer:
if %errorlevel%==1 GOTO ENABLEBL
if %errorlevel%==3 GOTO EOF
if %errorlevel%==2 (
shutdown -a
timeout /t 2 > NUL
shutdown -r -f -t 10 /c "Rebooting in 10 seconds"
set to=8
GOTO PREREBOOT
)

:ENABLEBL
echo.
echo.Running the commands to enable Bitlocker on the C: drive
echo.
echo.
start /min /wait "" manage-bde -protectors -enable c:
start /min /wait  "" manage-bde c: -resume
start /min /wait  "" manage-bde c: -on
start /min /wait  "" shutdown -a
if exist c:\utilities\enablebl.bat del /q c:\utilities\enablebl.bat > NUL
timeout /t 3
GOTO EOF

:EOF
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=bitreboot
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
