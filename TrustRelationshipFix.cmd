@ECHO OFF
IF EXIST \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd GOTO EOF
title Deprecated script - Support Engineering Tools
CLS
echo.
ECHO.Hello %username%!
ECHO.
ECHO.These services have been deprecated. 
ECHO.
ECHO.For additional questions or information please email supportengineertools@amazon.com 
ECHO.
ECHO.
TIMEOUT /T 20
EXIT

title Fix Trust Relationship - daviburt
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


rem https://w.amazon.com/index.php/ClientEngOps/Fix_Failed_Trust_Relationship_with_Domain
@echo $PSCredential = Get-Credential > %temp%\tr.ps1
@echo Reset-ComputerMachinePassword -Server ant.amazon.com -Credential $PSCredential >> %temp%\tr.ps1
powershell -file %temp%\tr.ps1
if exist %temp%\tr.ps1 del /s /q %temp%\tr.ps1

:EOF
CLS
:-------------------------------------
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=TRUSTRELATIONSHIP
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd
EXIT
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
