 @echo off
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


cls
echo.
echo.Attempting to kill OneDrive process...
timeout /t 3 > nul
taskkill /f /im OneDrive.exe
cls
echo.
echo.Attempting uninstall..
echo.
timeout /t 3 > nul
if exist %SystemRoot%\System32\OneDriveSetup.exe %SystemRoot%\System32\OneDriveSetup.exe /uninstall
if exist %SystemRoot%\SysWOW64\OneDriveSetup.exe %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
C:\Users\daviburt\AppData\Local\Microsoft\OneDrive\17.3.7076.1026\OneDriveSetup.exe  /uninstall 
MsiExec.exe /X{90160000-00BA-0409-0000-0000000FF1CE} /qn
REG Delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
REG Delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
REG Delete HKEY_CURRENT_USER\Software\Classes\CLSID\{1BF42E4C-4AF4-4CFD-A1A0-CF2960B8F63E}\InprocServer32 /f
REG Delete HKEY_CURRENT_USER\Software\Classes\CLSID\{7AFDFDDB-F914-11E4-8377-6C3BE50D980C}\InprocServer32 /f
REG Delete HKEY_CURRENT_USER\Software\Classes\CLSID\{82CA8DE3-01AD-4CEA-9D75-BE4C51810A9E}\InprocServer32 /f
REG Delete HKEY_CURRENT_USER\Software\Microsoft\OneDrive\DeletedDirectories /f
REG Delete "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /f
echo.
echo.Uninstall attempt completed...
echo.
timeout /t 10 > NUL

:EOF
CLS
:-------------------------------------
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=REMOVE-ONEDRIVE
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
