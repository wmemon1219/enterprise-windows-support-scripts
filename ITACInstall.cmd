@echo off
cls

title IT Administrative Controls Installer

:CHECKINGFORITAC
if exist %temp%\checked GOTO START_ADMIN_CHECK
IF EXIST "%programfiles%\ITACsvc\elevate.exe" GOTO ALREADYINSTALLED

:START_ADMIN_CHECK
CLS
REM REVISED 9-20-19
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
if not exist "%programfiles%\ITACsvc\ITACsvc.exe" GOTO ADMINPROMPT
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

cls

start /min /wait "" robocopy %workdir%\windows\Utilities\ITAC "%temp%\Amazonify\ITAC" /r:0 /w:0 /z /s > NUL
echo.
echo.Installing ITAC ^(IT Administrative Controls^)..
echo.
start /min /wait "" powershell -f "%temp%\Amazonify\ITAC\InstallITACsvc.ps1"
regedit.exe /S "%temp%\Amazonify\ITAC\safemode.reg" > NUL
timeout /t %20 > NUL

:CHECKINSTALLED
if exist "%programfiles%\ITACsvc\ITACsvc.exe" GOTO EOF
cls
echo.
echo.It doesn't appear to have installed correctly.
echo.
echo.1 - Yes
echo.2 - No
echo.
echo.
choice /c 12 /d 2 /n /t 30 /m "Did you want to try to install it again?: "
if %errorlevel% equ 1 GOTO ELEVATE
if %errorlevel% equ 2 (
set logname=nolog
GOTO EOF
)

:ALREADYINSTALLED
if exist %temp%\checked GOTO EOF
echo. > %temp%\checked
cls
echo.
echo.ITAC is already installed.
echo.
echo.Did you want to go through the install process anyways?
echo.
echo.1 - Yes
echo.2 - No
echo.
echo.
choice /c 12 /d 2 /n /t 30 /m "Answer: "
if %errorlevel% equ 1 GOTO ELEVATE
if %errorlevel% equ 2 (
set logname=nolog
GOTO EOF
)

:EOF
CLS
if exist %localappdata%\temp\fromupdater EXIT
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=ITACINSTALL
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------
del /q %temp%\checked > NUL
:EOFF
exit
