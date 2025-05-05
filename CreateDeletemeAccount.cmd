@echo off
title Create Deleteme Account - daviburt
cls
set accountname=deleteme
set accountpw=

net user | findstr /i deleteme > NUL
if %errorlevel% equ 0 (
cls
echo.
echo.I'm showing that the deleteme account already exists.
echo.
echo.
timeout /t 5
set logname=nolog
GOTO EOF
)

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


net user | findstr /i deleteme > NUL
if %errorlevel% equ 0 (
cls
echo.
echo.I'm showing that the deleteme account already exists.
echo.
echo.
timeout /t 5
set logname=nolog
goto EOF
)

:START
cls
echo.
echo.This is to be primarly used by IT
echo.
echo.Use case example would be a shell swap.
echo.
echo.**You will be prompted after every reboot to delete this account.
echo.
echo.The account user ID is^: deleteme
echo.
echo.Q - Quit
echo.
set /p accountpw=Enter a password for the account: 
if "%accountpw%"=="" GOTO START
if /i "%accountpw%"=="q" GOTO EOF

:CONFIRMPW
echo.
echo.Password:%accountpw%
echo.
echo.1 - Yes
echo.2 - No
echo.3 - Quit
echo.
CHOICE /C 123 /N /D 1 /T 60 /M "Is this the password you want to use?: "
if %errorlevel% EQU 1 GOTO makeaccount
if %errorlevel% EQU 2 GOTO START
if %errorlevel% EQU 3 GOTO EOF

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
net localgroup administrators %accountname% /add > NUL
WMIC USERACCOUNT WHERE "Name='%accountname%'" SET PasswordExpires=TRUE > NUL

    echo @timeout ^/t 15 > c:\users\public\deletemedelete.cmd
	echo elevate >> c:\users\public\deletemedelete.cmd
	echo cls >> c:\users\public\deletemedelete.cmd
	echo @echo off >> c:\users\public\deletemedelete.cmd
    echo echo. Ready to delete the deleteme account^?>> c:\users\public\deletemedelete.cmd
    echo echo.>> c:\users\public\deletemedelete.cmd
    echo echo. 1 - Yes>> c:\users\public\deletemedelete.cmd
    echo echo. 2 - No>> c:\users\public\deletemedelete.cmd
    echo echo.>> c:\users\public\deletemedelete.cmd
    echo CHOICE ^/c 12 ^/N ^/M ^"Answer?^: ^">> c:\users\public\deletemedelete.cmd
    echo IF %%ERRORLEVEL%% EQU 1 (>> c:\users\public\deletemedelete.cmd
	echo NET USER deleteme ^/DELETE>> c:\users\public\deletemedelete.cmd
	echo del /q c:\users\public\deletemedelete.cmd>> c:\users\public\deletemedelete.cmd
	echo )>> c:\users\public\deletemedelete.cmd
    echo IF %%ERRORLEVEL%% EQU 2 reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v Data /t Reg_SZ /d "c:\users\public\deletemedelete.cmd" /f ^> NUL>> c:\users\public\deletemedelete.cmd
    echo exit >> c:\users\public\deletemedelete.cmd
	reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v Data /t Reg_SZ /d "c:\users\public\deletemedelete.cmd" /f 
	cls
	if "%exists%"=="yes" GOTO EOF
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
echo.****
echo.You will be prompted to delete this account after every reboot.
echo.****
echo.
echo.
timeout /t 30
) else ( if %ERRORLEVEL% EQU 1 (
echo.
echo.
echo.That didn't seem to work. Run this script again or create an account manually.
echo.
timeout /t 30 > NUL
)
)

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=createdeleteme
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
