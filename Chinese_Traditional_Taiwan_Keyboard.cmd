@ECHO OFF

:START_ADMIN_CHECK
CLS
REM REVISED 1-15-2021
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
:--------------------------------------
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
REM THIS IS A TEMPORARY ADD OF THAT GROUP TO ADMIN AS A JUST IN CASE SOMETHING GOES WRONG AND ADMIN IS LOST, AT LEAST ANYONE IN THIS GROUP WILL HAVE IT UNTIL THEY'RE DONE
if not exist %temp%\TSAC mkdir %temp%\TSAC
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMGRP.txt
type %temp%\ADMGRP.txt | findstr /c:FS-TOOLSHED-IT
if %errorlevel% equ 0 GOTO GOTADMIN

(
echo.^[CmdletBinding^(^)^]
echo.$acc = "fs-toolshed-it"
echo.$group = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-544'" 
echo.$adm = $group.Name
echo.net localgroup $adm $acc /add
) > %temp%\TSAC\ADMINCHECK.ps1

powershell -f %temp%\TSAC\ADMINCHECK.ps1
:GOTADMIN
rmdir %temp%\TSAC /s /q

:START
cls
echo.
echo.Attempting to install the Keyboard now..
echo.
echo.
DISM.exe /Online /Add-Capability /CapabilityName:Language.Basic~~~zh-TW~0.0.1.0

:EOF
CLS
if exist %localappdata%\temp\fromupdater EXIT
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=CHINESE_KEYBOARD
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
