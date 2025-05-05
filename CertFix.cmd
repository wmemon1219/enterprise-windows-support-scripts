@echo off

cls

title Cert getter

REM ipconfig /all | findstr /c:"Primary Dns Suffix" | findstr /c:ant.amazon.com > NUL
REM if %errorlevel% equ 0 GOTO PING
REM cls
REM echo.
REM echo.This system isn't bound to the domain and won't work until it is..
REM echo.
REM echo.Quitting..
REM echo.
REM echo.
REM timeout /t 10
REM GOTO EOF

:PING
REM ping -n inside.amazon.com > NUL
REM if %errorlevel% equ 0 GOTO START_ADMIN_CHECK
REM cls
REM echo.
REM echo.
REM echo.I'm not able to reach the Amazon network for this to work..
REM echo.
REM echo.Connect to VPN or WPA2 to get your certificates.
REM echo.
REM echo.
REM timeout /t 3 > NUL
REM echo.Quitting..
REM echo.
REM timeout /t 10 
REM GOTO EOF


:START_ADMIN_CHECK
CLS
REM REVISED 1-25-19
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
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
REM THIS IS A TEMPORARY ADD OF THAT GROUP TO ADMIN AS A JUST IN CASE SOMETHING GOES WRONG AND ADMIN IS LOST, AT LEAST ANYONE IN THIS GROUP WILL HAVE IT UNTIL THEY'RE DONE
net localgroup administrators | findstr /i toolshed > NUL
if %errorlevel% equ 1 net localgroup administrators fs-toolshed-it /add > NUL

if not exist %localappdata%\temp\certmgr.exe xcopy \\toolshed.corp.amazon.com\share\Public\certmgr.exe %localappdata%\temp /y > NUL
if exist %localappdata%\temp\certmgr.exe %localappdata%\temp\certmgr.exe /s my  /del -all > NUL

REM COPYING CERTIFICATES TO THE LOCAL MACHINE
robocopy %workdir%\Windows\Software\Certificates\Internet_Explorer\*.cer %appdata% /xo > NUL

REM FOR LOOP TO IMPORT EACH CERTIFICATE IN THE FOLDER. 
echo.
echo.Importing Certificates into the user profile.
echo.
echo.
for %%p in ("%workdir%\Windows\Software\Certificates\Internet_Explorer\*.crt") do start /min /wait "" certutil -addstore -user -f "My" "%%p"
REM PUTS THE ROOT CERTIFICATE IN THE TRUSTED ROOT STORE
certutil -addstore -user -f "Trusted Root Certification Authorities" "%workdir%\Windows\Software\Certificates\Internet_Explorer\Amazon.com Internal Root Certificate Authority.crt"

REM GETTING FIREFOX PATH
FOR /F "usebackq delims==" %%i IN (`dir "%appdata%\mozilla\firefox\profiles\" /b`) DO SET firepath="%appdata%\mozilla\firefox\profiles\%%i"

REM IMPORTS CERTIFICATES INTO FIREFOX USING A FOR LOOP
for %%p in ("%workdir%\Windows\Software\Certificates\Firefox\*.der") do start /min /wait "" certutil -A -n "%%p" -t "TC,TC,TC" -i "%%p" -d "%firepath%"

REM RENAMES THE POLICY FILE
ren %WINDIR%\System32\GroupPolicy\Machine\Registry.pol Registry.pol.bak > NUL
cls

REM GROUP POLICY UPDATE THAT GENERALLY GETS THE REGISTRY.POL FILE BACK
gpupdate /force /wait:0

:EOF
if exist %TEMP%\AMAZONIFY\FROMUPDATER EXIT
CLS
:-------------------------------------
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==NOLOG set logname=certfix
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
