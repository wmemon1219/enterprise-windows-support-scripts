@echo off
CLS

TITLE WorkDocs Cache Cleaner - daviburt

REM CHECKING FOR WORKDOCS
if not exist "%programfiles%\Amazon\AWSWorkDocsDriveClient\AWSWorkDocsDriveClient.exe" (
CLS
echo.
echo.WorkDocs is not installed on this system..
echo.
echo.Exiting..
echo.
timeout /t 20
EXIT
)

:WORKTASK
REM CHECKING IF A TASK FOR THIS IS IN PLACE OR NOT
schtasks /query | findstr ClearWorkDocsCache | findstr Ready > NUL
if %errorlevel% equ 0 set task=yes

REM 20GB IN BYTES TO SET AS THE LOWEST SPACE THAT WILL BE SET
:CHECKFREESPACE
REM THIS CHECKS THE FREESPACE ON THE DRIVE
set space_cmd=21474836480
FOR /F "delims=" %%i IN ('dir c:\') DO set space=%%i
set process_01=%space%
set process_02=%process_01:~-26%
set process_03=%process_02:.=%
set process_04=%process_03: bytes free=%
set /a FREESPACE=%process_04%   / 1073741824
CLS
echo.
echo.

REM CONVERTS TO GB
set /A LIMIT=%space_cmd:~0,-3%/1024/1024
REM IF THE FREESPACE IS LOWER THAN 20GB IT WILL TRY TO FREE UP SPACE USING THE WORKDOCS FREE SPACE SCRIPT
if %FREESPACE% LSS %limit% goto REMOVE_CACHE
REM if /i %computername%==US-A9-4478 GOTO EOF
echo.
echo.The limit is set to %limit%GB and you have more free space than this..
echo.
echo.
echo.Y - Yes
echo.N - No ^(Default Answer^)
echo.
rem if not "%task%"=="yes" echo.T - Create Scheduled Task ^(Requires Administrative Rights^)
echo.
echo.
choice /c YNT /n /d N /t 30 /m "Still Clear WorkDocs Cache?: "
if %errorlevel% equ 1 GOTO REMOVE_CACHE
if %errorlevel% equ 2 (
set logname=nolog
GOTO EOF
)
if %errorlevel% equ 3 GOTO CHECKFREESPACE


:TASKSETUP
if exist %~DP0WorkDocs_Filling_up_Your_Hard_Drive.cmd xcopy %~DP0WorkDocs_Filling_up_Your_Hard_Drive.cmd %userprofile%\documents\ /y >NUL
if not exist %userprofile%\documents\WorkDocs_Filling_up_Your_Hard_Drive.cmd (
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
xcopy %workdir%\windows\scripts\WorkDocs_Filling_up_Your_Hard_Drive.cmd %userprofile%\documents\ /y > NUL
)

if exist "%userprofile%\documents\WorkDocs_Filling_up_Your_Hard_Drive.cmd" schtasks /create /sc hourly /mo 1 /tn "ClearWorkDocsCache" /tr %userprofile%\documents\WorkDocs_Filling_up_Your_Hard_Drive.cmd /ru "SYSTEM"

timeout 10
EXIT

:REMOVE_CACHE
REM CLOSING WORKDOCS IF IT IS RUNNING
tasklist | findstr /i AWSWorkDocsDriveClient > NUL
if %errorlevel% equ 0 taskkill /f /im AWSWorkDocsDriveClient*

REM CLEARING CACHE FOLDERS
if exist "%userprofile%\Documents\WorkDocs Drive\Recovered Files" (
rmdir "%userprofile%\Documents\WorkDocs Drive\Recovered Files" /s /q
mkdir "%userprofile%\Documents\WorkDocs Drive\Recovered Files"
)
if exist %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\links (
rmdir %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\links /s /q
mkdir %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\links
)
if exist %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\cache (
rmdir %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\cache /s /q
mkdir %appdata%\Amazon\AWSWorkDocsDriveClient\cacheData\cache
)

CLS
echo.
echo.Cleared WorkDocs Cache Folders..
echo.
timeout 10


:WORKLOOP
REM OPENING WORKDOCS IF IT FAILS TO RE-OPEN
tasklist | findstr /i AWSWorkDocsDriveClient > NUL
if %errorlevel% equ 1 (
CLS
start "" "%programfiles%\Amazon\AWSWorkDocsDriveClient\AWSWorkDocsDriveClient.exe"
echo.
echo.Attempting to load WorkDocs..
echo.
echo.Sometimes this fails after clearing the Cache but a reboot should fix that..
echo.
echo.
timeout 10
if not "%counter%"=="10" (
set /a counter="%counter%"+1
GOTO WORKLOOP
)
)

:PERSIST
REM IF PERSIST IS INSTALLED IT WILL RE-OPEN IT IF IT ISN'T RUNNING
IF NOT EXIST "C:\Program Files (x86)\Persist\PersistUI.exe" GOTO EOF
tasklist | findstr /i persist > NUL
if %errorlevel% equ 1 (
if exist "C:\Program Files (x86)\Persist\PersistUI.exe" start "" "C:\Program Files (x86)\Persist\PersistUI.exe"
)

:EOF

CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=CLEARWDCACHE
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
