@echo off
cls
set counter=1
title Certificate Getter - daviuburt

for /f "tokens=4" %%I in ('net user /domain %username% ^| findstr /c:"Full Name"') do set "UsernameFirst=%%I"

REM THIS WILL DO A GPUDPATE AS SOON AS IT DETECTS IT IS ON THE CORPORATE NETWORK
REM ALSO TRIES TO INSTALL ITAC FROM SOFTWARE CENTER

:CHECKDOMAIN
ipconfig /all | findstr /c:"Primary Dns Suffix" | findstr /c:ant.amazon.com > NUL
if %errorlevel% equ 0 GOTO PING
cls
echo.
echo.This system isn't bound to the domain and won't work until it is..
echo.
echo.Quitting..
echo.
echo.
timeout /t 10
GOTO EOF

:PING
cls
echo.
echo.Verifying I'm able to connect to the Amazon network..
echo.
timeout /t 5 > NUL
cls
ping -n 2 inside.amazon.com > NUL
if %errorlevel% equ 0 GOTO ITAC
cls
echo.
echo.
echo.I'm not able to reach the Amazon network for this to work..
echo.
echo.
echo.Attempt %counter% of 100
echo.
echo.
timeout /t 10 /nobreak
if not %counter%==100 GOTO PING
cls
echo.
echo.Seems I can't connect to the network so I'm going to give up, sorry..
echo.
echo.
timeout /t 20
GOTO EOF

:ITAC
set counter=0
if NOT exist "C:\Program Files\ITACsvc\elevate.exe" (
if exist "C:\WINDOWS\CCM\ClientUX\SCClient.exe" start /wait "" "C:\WINDOWS\CCM\ClientUX\SCClient.exe" softwarecenter:SoftwareID=ScopeId_6C900AD6-A53B-4C44-B96C-1002E20C5DF9/Application_3cccc9a9-3f0c-44b4-891f-f4e7ea388092
)

:POLICYUPDATE
cls
echo.
echo.Updating Policies..
echo.
gpupdate /force /wait:0 | findstr /c:"User Policy update has been successfully triggered." > NUL
if %errorlevel% equ 0 (
cls
echo.Your policies are all set!
echo.
echo.Have a great day, %UsernameFirst%!
echo.
timeout /t 10
GOTO EOF
)

if not %counter%==10 (
set /a counter=%counter%+1
cls
echo.
echo.Couldn't update the policies.. trying again..
echo.
echo.Attempt %counter% of 10
echo.
echo.
timeout /t 10
GOTO POLICYUPDATE
)

:FAILED
cls
echo.
echo.Unfortunately that didn't work..
echo.
echo.
timeout /t 10
GOTO EOF

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=GPUPDATE
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit


