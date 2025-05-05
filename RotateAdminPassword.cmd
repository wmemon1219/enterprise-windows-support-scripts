@echo off
CLS

title Local Administrator password rotater
rem https://share.amazon.com/sites/gits-kb/Pages/Windows/Rotating%20Window%20local%20administrator%20credentials.aspx

REM SETTING VARIABLE FOR STOPPING THE SERVICES BELOW WHEN RAN THE FIRST TIME
set servicetype=Stop
set equal=0

:START_ADMIN_CHECK
REM REVISED 3-17-2021
REM SETTING SOURCE DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
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
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\ADMGRP.txt
type %temp%\ADMGRP.txt | findstr /c:FS-TOOLSHED-IT > NUL
if %errorlevel% equ 0 GOTO START

(
echo.^[CmdletBinding^(^)^]
echo.$acc = "fs-toolshed-it"
echo.$group = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-544'" 
echo.$adm = $group.Name
echo.net localgroup $adm $acc /add
) > %temp%\ADMINCHECK.ps1

powershell -f %temp%\ADMINCHECK.ps1

:START
REM THES TWO SECTIONS ARE SKIPPED BECAUSE IT DIDN'T SEEM NECESSARY TO LIMIT THIS TO IT
REM BUT IT REMAINS IN CASE THERE IS SOME INITIATIVE TO MAKE THAT NECESSARY IN THE FUTURE

GOTO ASKTOCONTINUE
REM THIS WILL CHECK IF IT'S RUN WITH THE ADMINISTRATOR ACCOUNT
whoami | findstr /i administrator > NUL
if %errorlevel% equ 0 GOTO ASKTOCONTINUE

REM GETTING ACCOUNT INFO ABOUT THE CURRENT USER IF NOT RUN UNDER THE ADMINISTRATOR ACCOUNT
NET USER /DOMAIN %USERNAME% > %temp%\accountinfo.txt
if not exist %temp%\accountinfo.txt GOTO NOGO
REM CHECKING A FILE FOR PERMISSIONS THAT ONLY IT WOULD HAVE
for %%a in (LocalPasswordAdmin,deskside,FS-TOOLSHED-IT) do (
type %temp%\accountinfo.txt | findstr /i %%a > NUL
if %errorlevel% equ 0 GOTO ASKTOCONTINUE
)

:NOT-IT
cls
echo.
echo.Unfortunately it doesn't appear %username% has the proper permissions to run this script.
echo.
echo.If you are IT and this happened, please email me - daviburt@amazon.com
echo.
echo.Thanks..
echo.
timeout /t 15 
GOTO EOFF

:ASKTOCONTINUE
cls
echo.
echo.This will rotate the local administrator account password on the computer.
echo.
echo.Are you sure you want to continue?
echo.
echo.
echo.1 - Yes
echo.2 - No ^(Default^)
echo.
echo.
choice /c 12 /n /d 2 /t 60 /m Answer: 
if %errorlevel% equ 1 GOTO CHECKADMINDATE
if %errorlevel% equ 2 (
GOTO EOFF
)


:CHECKADMINDATE
REM THIS WILL CHECK IF THE ADMIN ROTATION DATE HAS ALREADY BEEN CHANGED
reg query HKLM\SOFTWARE\AmznInternal | findstr AdminAccountPasswordLastRandomized | findstr 2020 > NUL
REM DELETING AN ACME FILE RELATED TO ROTATING THE ADMIN PASSWORD
if %errorlevel% equ 0 del C:\PROGRA~2\Quarantine\State\ServiceAgents\AccountManagementAgent.xml /q > NUL 
if %errorlevel% equ 1 (
set 

:SERVICES
cls
echo.
echo.Changing the ACME services..
echo.
REM MANAGING SERVICES RELATED TO ACME
net start | findstr /i acmeguardian > NUL
if %errorlevel% equ %equal% net %servicetype% acmeguardian
net start | findstr /i quarantine > NUL
if %errorlevel% equ %equal% net %servicetype% quarantine
IF "%COUNTER%"=="" (
REM THIS WILL CHANGE THE COUNTER VARIABLE SO IT WILL RUN THROUGH THE ACME SERVICES STARTING ONLY TWO TIMES
SET /A COUNTER=%COUNTER%+1
GOTO SERVICES
)
REM CHANGES THE COMMAND FROM STOP TO START FOR MANAGING THE ACME SERVICES AND RELOADS THE MODULES IN ACME
if "%servicetype%"=="Start" (
quarantine.exe /rm
GOTO EOF
)

:ROTATE
CLS
echo.
echo.Making changes to rotate the administrative password..
timeout /t 5 /nobreak > NUL
REM MODIFING REGISTRY AND REMOVING XML FILE TO SET THE TO FORCE A ROTATION OF THE ADMIN PASSWORD
REG Add "HKLM\SOFTWARE\AmznInternal" /F /v "AdminAccountPasswordLastRandomized" /d "01/11/2020 09:18:42"

set servicetype=Start
set equal=1
set counter=
GOTO CHECKADMINDATE

:NOGO
cls
echo.
echo.Unfortunately something has gone wrong..
echo.
echo.
timeout /t 10
GOTO EOFF

:EOF
CLS

:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=ADMINROTATE
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
REM IF THE FS-TOOLSHED-IT GROUP IS STILL ADMINSTRATIVE IT WILL REMOVE IT FROM THE ADMINISTRATORS GROUP
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\ADMINCHECK.txt
type %temp%\ADMINCHECK.txt | findstr /c:FS-TOOLSHED-IT > NUL
if %errorlevel% equ 1 GOTO CLEANUP

(
echo.^[CmdletBinding^(^)^]
echo.$acc = "fs-toolshed-it"
echo.$group = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-544'" 
echo.$adm = $group.Name
echo.net localgroup $adm $acc /del
) > %temp%\ADMINCHECK.ps1

powershell -f %temp%\ADMINCHECK.ps1
:CLEANUP
del /q %temp%\ADMINCHECK* > NUL
del /q %temp%\accountinfo* > NUL
exit
