@echo off
title Local account creator
:START_ADMIN_CHECK
CLS
REM REVISED 11-14-19
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
echo.
echo.This is to be primarly used by IT
echo.
echo.Q to quit
echo.
echo.
set /p accountname=What did you want the local account to be called?:
if /i "%accountname%"=="q" GOTO EOF
if /i "%accountname%"=="" goto RUNNING_AS_ADMIN
if /i not "%accountname%"=="q" goto password
if /i not "%accountname%"==""goto RUNNING_AS_ADMIN

:password
echo.
echo.It needs to meet these requirements:

echo.   has at least 8 characters;
echo.   has uppercase letters;
echo.   has lowercase letters;
echo.   has numbers;
echo.   has symbols, such as ` ! " ? $ ? % ^ & * ( ) _ - + = { [ } ] : ; @ ' ~ # | \ < , > . ? /
echo.   is not like your previous passwords;
echo.   is not your name;
echo.   is not your login;
echo.   is not your friend's name;
echo.   is not your family member's name;
echo.   is not a dictionary word;
echo.   is not a common name.
echo.
echo.
echo.Q to quit
echo.
echo.
set /p accountpw=What did you want the password to be for the local account?:
if /i "%accountpw%"=="q" GOTO EOF
if /i "%accountpw%"==""goto password
if /i not "%accountpw%"=="q" goto confirm
if /i not "%accountpw%"=="" goto confirm

:confirm
echo.
echo.Q to quit
echo.
echo.Local Account Name:"%accountname%"
echo.Local Account Password:%accountpw%
echo.
echo.
echo.To confirm, (y/n)
set /p confirm=you want to create a local account with this information, right?: 
if /i "%accountname%"=="q" GOTO EOF
if /i "%confirm%"=="y" goto makeaccount
if /i "%confirm%"=="n" goto RUNNING_AS_ADMIN
if /i "%confirm%"==""goto confirm

:makeaccount
cls
echo.
echo.
echo.Creating local account
net user "%accountname%" /DELETE
cls
net user "%accountname%" %accountpw% /ADD /PASSWORDCHG:NO > NUL
timeout /t 5 > NUL
net user "%accountname%" /active:yes > NUL
net localgroup administrators "%accountname%" /add > NUL
WMIC USERACCOUNT WHERE "Name='%accountname%'" SET PasswordExpires=FALSE > NUL
GOTO CHECK

:CHECK
net localgroup administrators | findstr /i "%accountname%" > NUL
if %ERRORLEVEL% EQU 0 (
echo.
echo.Please try the local account to make sure you have
echo.everything ready in case this system doesn't bind
echo.to the domain..
echo.
echo.Shift-Right-Click on CMD will give you an option to
echo.'Run as a different user' to test against..
echo.
echo.Waiting..
echo.
pause
) else ( if %ERRORLEVEL% EQU 1 (
echo.
echo.
echo.That didn't seem to work, try again..
echo.
timeout /t 10 > NUL
goto RUNNING_AS_ADMIN
)
)

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=createlocal
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
