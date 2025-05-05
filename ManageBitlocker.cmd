@echo off

title Managing Bitlocker
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


REM %temp%\managebitlocker.cmd xcopy /y "%workdir%\Windows\Scripts\managebitlocker.cmd" %temp% > NUL

REM if not exist %temp%\managebitlocker.cmd (
REM cls
REM echo.
REM echo.Unfortunately something has gone wrong..
REM echo.Please see your local IT or contact Global IT.
REM echo.
REM echo.https://it.amazon.com
REM echo.
REM timeout /t 20
REM GOTO EOF
REM )

REM if %runonce%==no %temp%\managebitlocker.cmd

set drive=C

:START
mode con: cols=60 lines=30
cls
echo.
manage-bde %drive%: -status | findstr /c:"Conversion Status"
manage-bde %drive%: -status | findstr /c:"Percentage Encrypted"
manage-bde %drive%: -status | findstr /c:"Protection Status" | findstr "Protection"
echo.
echo.       Bitlocker Management
echo.----------------------------------
manage-bde %drive%: -status | findstr /i /c:Percentage | findstr /c:100 > NUL
if %errorlevel% equ 1 (
echo.Z - Shutdown this computer when encryption has completed
echo.----------------------------------
)
echo.
echo.1 - Pause / Suspend Bitlocker
echo.2 - Resume Bitlocker
echo.3 - Change Drive Letter
echo.
echo.----------------------------------
echo.        DRIVE %drive%:
echo.
echo.4 - Turn Bitlocker Off
echo.5 - Turn Bitlocker On
echo.6 - Status
echo.
echo.7 - Manage Bitlocker - Control Panel
echo.8 - Refresh 
echo.
echo.Q - Quit
echo.
set /p choice=Choose an option: 
IF %choice%==1 GOTO PAUSE
IF %choice%==2 GOTO RESUME
IF %choice%==3 GOTO CDRIVE
IF %choice%==4 (
echo.
echo.Are you sure?
echo.
echo.1 - Yes
echo.2 - NO
echo.
choice /c 12 /n /d 2 /t 30 /m "Answer: "
if %choice%==1 GOTO BITOFF
if %errorlevel% equ 2 GOTO START
)
IF %choice%==5 GOTO BITON
IF %choice%==6 GOTO BITSTATUS
IF %choice%==7 GOTO MANAGEBL
IF %choice%==8 (
CLS
GOTO START
)
IF /i %choice%==q GOTO EOF
IF /i %choice%==z GOTO DONTSLEEP
IF %choice%=="" GOTO START

:PAUSE
manage-bde %drive%: -pause > NUL
manage-bde -protectors -disable %drive%: > NUL
GOTO START

:RESUME
manage-bde %drive%: -resume > NUL
manage-bde -protectors -enable %drive%: > NUL
GOTO START

:BITSTATUS
cls
echo.
mode con: cols=80 lines=30
manage-bde %drive%: -status
pause
GOTO START

:BITOFF
manage-bde %drive%: -off > NUL
cls
echo.
mode con: cols=80 lines=30
GOTO START

:BITON
manage-bde %drive%: -on > NUL
cls
echo.
mode con: cols=80 lines=30
GOTO START

:MANAGEBL
control /name Microsoft.BitLockerDriveEncryption
GOTO START

:CDRIVE
cls
echo.
echo.What driver letter ONLY?
echo.
echo.1 - Main Menu
echo.2 - Quit
echo.
wmic logicaldisk get name | findstr ":"
echo.
echo.
set /p drive=Answer: 
if /i "%drive%"=="" GOTO CDRIVE
if /i "%drive%"=="1" GOTO START
if /i "%drive%"=="2" GOTO EOF
if /i "%drive%"=="%drive%:" GOTO CDRIVE
if /i exist %drive%: GOTO START
if /i not exist %drive%: (
echo.
echo.
echo.That drive doesn't exist..
timeout /t 3 > NUL
GOTO CDRIVE
)

:DONTSLEEP
REM THIS SECTION IS THE BEGINNING OF WAITING FOR THE ENCRYPTION TO COMPLETE AND THEN SHUTDOWN WHEN ITS FINISHED
set logname=skiplog
start /min /wait "" "%workdir%\Windows\Software\DontSleep\DontSleep.bat" 
set logname=

manage-bde %drive%: -on > NUL
manage-bde %drive%: -resume > NUL

:SHUTITDOWN
mode con: cols=67 lines=30
cls
WMIC Path Win32_Battery Get BatteryStatus | findstr 2 > NUL
if %errorlevel% equ 1 (
echo.I recommend plugging this machine into power while it encrypts.
echo.
)
manage-bde %drive%: -status | findstr /i /c:Percentage | findstr /c:100 > NUL
if %errorlevel% equ 1 (
echo.
echo.Waiting for encryption to complete..
echo.
manage-bde %drive%: -status | findstr /i "Conversion"
manage-bde %drive%: -status | findstr /i "Percentage Encrypted"
timeout /t 30
GOTO SHUTITDOWN
)
if %errorlevel% equ 0 start "" shutdown -s -f -t 300
tasklist | findstr /i "DontSleep" > NUL
if %errorlevel% equ 0 tskill DontSleep* > NUL

:EOF
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=ManageBitlocker
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------
if exist %temp%\managebitlocker.cmd del /q %temp%\managebitlocker.cmd > NUL

:EOFF
set runonce=yes
exit
