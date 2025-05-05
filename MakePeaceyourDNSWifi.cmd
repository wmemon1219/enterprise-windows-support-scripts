@echo off
:START_ADMIN_CHECK
CLS
REM REVISED 3-4-2020
REM SETTING SOURCE DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
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


    echo.
    echo Now changing DNS Settings
    timeout /t 3
    echo.
    netsh interface ipv4 set dns "Wi-Fi" dhcp
    echo.
    echo Your Wi-Fi DNS settings have been set to default
    echo.
    timeout /t 5
	%workdir%\Windows\Utilities\Blat\blat -to jmakepe@amazon.com from toolshed@amazon.com -subject "Someone just fixed their DNS" -body "You're a badass"
    exit