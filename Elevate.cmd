@echo off
title Ellavayshunn - daviburt

echo %username% | findstr /i thorpeb > NUL
if %errorlevel% equ 0 exit

cls

REM VARIABLE FOR THE ADMIN PART OF THIS SCRIPT
set admincounter=0
set elevatecounter=0
CLS
start /min "" gpupdate /force /wait^:0

REM REVISED 1-22-2021
REM SETTING SOURCE DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
if exist \\toolshed.corp.amazon.com\share\Windows set workdir=\\toolshed.corp.amazon.com\share
REM FPH
:--------------------------------------
REM WORKING FOLDER FOR CHECKING ADMIN GROUPS/RIGHTS
if not exist %temp%\TSAC mkdir %temp%\TSAC

REM CHECKING IF ELEVATE ELEVATE IS INSTALLED
IF NOT exist "C:\Program Files\ITACsvc\elevate.exe" GOTO ITACINSTALL

:CHECKADMIN
REM CHECKING IF THE SCRIPT IS RUN AS ADMINISTRATOR
FOR /f "usebackq" %%f IN (`whoami /priv`) DO IF "%%f"=="SeTakeOwnershipPrivilege" GOTO GOTADMIN

REM CHECKING IF THE TOOLSHED PERMISSIONS GROUP IS AN ADMIN ALREADY AND THEN WILL CHECK THE ACCOUNT THAT IS RUNNING IT TO SEE IF IT IS PART OF THAT GROUP TO RUN THINGS AS ADMIN
REM WITHOUT ACTUALLY BEING IN THE ADMINISTRATORS GROUP
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMGRP.txt
type %temp%\TSAC\ADMGRP.txt | findstr /c:FS-TOOLSHED-IT
if %errorlevel% equ 0 (
net user /domain %username% | findstr /c:FS-TOOLSHED-IT > NUL
if %errorlevel% equ 0 GOTO GOTADMIN
)

REM I HAVE A SPECIFIC PERMISSIONS GROUP I USE SO IF IT SEES I'M RUNNING THIS SCRIPT IT WILL LOOK FOR THAT GROUP ON THE SYSTEM TO SEE THAT I HAVE ADMIN RIGHTS
:4DAVIBURT
echo %username% | findstr /i daviburt > NUL
if %errorlevel% equ 1 GOTO CHECKADMINGROUP 
net localgroup administrators | findstr /c:FS-TOOLSHED > NUL
if %errorlevel% equ 0 GOTO GOTADMIN

:CHECKADMINGROUP
REM CHECKING IF THE CURRENT ACCOUNT HAS ADMIN RIGHTS
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMNGRP.txt
type %temp%\TSAC\ADMNGRP.txt | findstr %username% > NUL
if %errorlevel% equ 0 GOTO GOTADMIN
if %errorlevel% equ 1 GOTO GETADMIN

:CHECKDOMAIN
REM IF THIS IS NOT BOUND TO THE DOMAIN IT WILL SKIP CHECKING IF THE ACCOUNT IS AN IT ADMIN ACCOUNT OR NOT
ipconfig /all | findstr /c:"Primary Dns Suffix" | findstr /c:ant.amazon.com > NUL
if %errorlevel% equ 1 (
CLS
echo.
echo.I cannot seem to verify your account to see if this should be elevated as IT or not..
echo.
echo.Are you IT and want to Elevate?
echo.
echo.
echo.1 - Yes
echo.2 - No and Quit
echo.
echo.
CHOICE /N /C:12 /D 2 /T 60 /M "Answer: "
if %errorlevel% equ 1 GOTO RUNELEVATE
if %errorlevel% equ 2 (
set logname=nolog
GOTO EOF
)


:GETADMIN
REM RUNS THE ELEVATE SERVICE TO GET ADMIN RIGHTS IF IT
net user /domain %username% | findstr /i admin >  NUL
if %errorlevel% EQU 0 (
if not exist "C:\Program Files\ITACsvc\elevate.exe" GOTO ITACINSTALL
if %elevatecounter%==0 (
CLS
set /a elevatecounter=%elevatecounter%+1
if %elevatecounter% GEQ 2 GOTO NOADMIN

:RUNELEVATE
REM THIS IS FOR SKIPPING THE DOMAIN CHECK ABOVE
if exist "C:\Program Files\ITACsvc\elevate.exe" start /wait "" "C:\Program Files\ITACsvc\elevate.exe"
if not %elevatecounter% LSS 2 GOTO CHECKADMIN 
) )

:ITACINSTALL
REM WILL REQUEST TO INSTALL THE ITAC SERVICE IF THE USERNAME VARIABLE
REM ECHOS OUT TO BE PART OF AN ADMIN ANT GROUP
REM CHECKS JUST TO MAKE SURE THE ACCOUNT RUNNING DOESN'T HAVE ADMIN FIRST THOUGH
if exist "C:\Program Files\ITACsvc\elevate.exe" GOTO NOADMIN
echo.
echo.I need administrative rights but ITAC isn't installed.
echo.
if exist C:\Windows\CCM\ClientUX\SCClient.exe (
echo.I need you to install the AmazonITAC package from Software Center to try and get this to work.
echo.
echo.It may say it's already installed, so you may have to do an uninstall first.
echo.
gpupdate /force /wait:0
echo.
echo.I recommend waiting 15 seconds in case Software Center needs a wee bit of time to populate its list..
echo.
timeout /t 15
tasklist | findstr /i SCClient > NUL
if %errorlevel% equ 0 tskill SCClient > NUL
CLS
echo.
echo.Launching Software Center..
echo.
echo.
echo.Good luck!
echo.
start /wait "" "C:\WINDOWS\CCM\ClientUX\SCClient.exe" softwarecenter:SoftwareID=ScopeId_6C900AD6-A53B-4C44-B96C-1002E20C5DF9/Application_3cccc9a9-3f0c-44b4-891f-f4e7ea388092
if exist "C:\Program Files\ITACsvc\elevate.exe" GOTO GETADMIN
set /a admincounter=%admincounter%+1
if not %admincounter%==2 GOTO CHECKADMIN
) 

REM WILL RUN IF IT DOESN'T SEEM TO SEE THAT THE ACCOUNT RUNNING IT HAS ADMIN RIGHTS
:NOADMIN
REM net localgroup administrators | findstr /i %username% > NUL
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMNGRP.txt
type %temp%\TSAC\ADMNGRP.txt | findstr %username% > NUL
if %errorlevel% equ 0 GOTO EOF
CLS
echo.
echo.The account %username% doesn't have administrative rights on this machine.
echo.
echo.1 - Try to elevate again?
echo.
echo.
echo.----------IT-ONLY-------------------
echo.2 - Still continue? (Select if you have already elevated your IT admin account)
echo.3 - Enter your user ID if it's different that the one above.
echo.       This should start the elevate process if doesn't have admin rights on this machine.
echo.----------IT-ONLY-------------------
echo.
echo.4 - Quit
echo.
echo.
CHOICE /N /C:1234 /D 4 /T 45 /M "Answer: "
IF %ERRORLEVEL% EQU 1 (
set admincounter=0
set elevatecounter=0
GOTO CHECKADMIN
)
IF %ERRORLEVEL% EQU 2 GOTO EOF
IF %ERRORLEVEL% EQU 3 GOTO GETUSERID
IF %ERRORLEVEL% EQU 4 GOTO EOF

:GETUSERID
echo.
echo.Q - Quit
echo.
echo.Z - Start Over
echo.
set /p userid=What is your user ID:
if %userid%=="" GOTO GETUSERID
if /i %userid%==q GOTO EOF
if /i %userid%==z GOTO CHECKADMIN
set username=%userid%
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMNGRP.txt
type %temp%\TSAC\ADMNGRP.txt | findstr /i %username% > NUL
if %errorlevel% EQU 0 GOTO EOF
if %errorlevel% EQU 1 (
set admincounter=0
set elevatecounter=0
GOTO CHECKADMIN
)

:ADMINPROMPT
ECHO CreateObject("Shell.Application").ShellExecute Chr(34) ^& "%WINDIR%\System32\cmd.exe" ^& Chr(34), "/K " ^& Chr(34) ^& "%~dpfx0 %*" ^& Chr(34), "", "runas", 1 >"%TEMP%\RunAs.vbs"
WScript.exe "%TEMP%\RunAs.vbs"
GOTO EOF

:GOTADMIN
CLS
echo.
echo.This account has elevated privileges.
echo.
echo.
timeout /t 5

REM VERIFYING THAT THE IT-ADMINS-EXCEPTION GROUP IS ADDED FOR IT ADMIN RIGHTS
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMNGRP.txt
type %temp%\TSAC\ADMNGRP.txt | findstr /i it-admins-exception > NUL
if %errorlevel% equ 1 (
(
echo.^[CmdletBinding^(^)^]
echo.$acc = "it-admins-exception"
echo.$group = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-544'" 
echo.$adm = $group.Name
echo.net localgroup $adm $acc /add
) > %temp%\TSAC\ADMINCHECK.ps1

powershell -f %temp%\TSAC\ADMINCHECK.ps1

)
REM net localgroup administrators it-admins-exception /add > NUL
REM THIS WILL LOAD THE AMAZON DEFAULT FIREWALL RULES IF IT CAN
if exist "%PROGRAMFILES(X86)%\Quarantine\Amazon_Default_Firewall_Policy.wfw" start /min "" netsh advfirewall import "%PROGRAMFILES(X86)%\Quarantine\Amazon_Default_Firewall_Policy.wfw"

REM THIS SECTION WILL GIVE THE CURRENT OWNER OF THE MACHINE ADMIN RIGHTS IF THEY QUALIFY
:GIVEADMIN
if exist "%PROGRAMFILES(X86)%\Quarantine\quarantineui.exe" (
for /f "tokens=5" %%a in ('quarantine /currentowner') do set userid=%%a
)

if not "%userid%"=="" (
powershell Get-LocalGroupMember -SID 'S-1-5-32-544' > %temp%\TSAC\ADMNGRP.txt
type %temp%\TSAC\ADMNGRP.txt | findstr /i %userid% > NUL
if %errorlevel% equ 1 (
set elevate=yes
start /min "" "%workdir%\Windows\Scripts\GrantAdminRights.cmd"
)
)

:EOF
CLS
echo.
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\madethis.txt (
type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\madethis.txt
echo.
echo.
timeout /t 3 > NUL
)
rmdir %temp%\TSAC /s /q > NUL

REM THIS WILL CHANGE THE SYSTEM VARIABLES IF IT'S A WORKSPACES SYSTEM
REM systeminfo | findstr /C:"AWS PV Network Device" > NUL
REM if %errorlevel% equ 1 GOTO EOFF

REM if not exist d:\users\%username% GOTO EOFF

REM set userprofile=d:\users\%username%
REM set appdata=D:\Users\%username%\AppData\Roaming
REM set localappdata=D:\Users\%username%\AppData\Local
REM [CmdletBinding()]
REM $acc = "fs-toolshed-it"
REM $group = Gwmi win32_group -Filter "Domain='$env:computername' and SID='S-1-5-32-544'" 
REM $adm = $group.Name


REM net localgroup $adm $acc /add
:EOFF
exit
