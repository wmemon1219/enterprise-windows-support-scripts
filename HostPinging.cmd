:ASK
@echo off
title host pinger

set counter=1
cls
echo.
if not "%host%"=="" (
echo.Previous Host Checked: %host%
echo.
echo.You can press the up and down arrows to cycle through previous servers
echo.
)
echo.
echo.What is the hostname you want to test?
echo.
echo.Q - Quit
echo.
set /p host=Answer: 
if "%host%"=="" GOTO ASK
if /i "%host%"=="q" GOTO EOF

:ASK_OFF_ON
cls
echo.
echo.Are you testing for %host% to go Offline or Online?
echo.
echo.1 - Online
echo.2 - Offline
echo.
echo.3 - Quit
echo.
choice /c 123 /n /d 3 /t 60 /m "Answer: "
if %errorlevel% equ 1 (
set mode=online
set status=ttl
)
if %errorlevel% equ 2 (
set mode=offline
set status="timed out"
)
if %errorlevel% equ 3 GOTO EOF

:HOSTCHECK
ping -n 1 %host% | findstr /c:"Ping request could not find host"
if %errorlevel% equ 1 GOTO PINGSTART
echo.
echo.I'm unable to find %host% via the ping command.
echo.
echo.How did you want to proceed?
echo.
echo.1 - Enter hostname again
echo.2 - Proceed anyway
echo.
echo.3 - Quit
echo.
choice /c 123 /n /d 3 /t 60 /m "Answer: "
if %errorlevel% equ 1 GOTO ASK
if %errorlevel% equ 2 GOTO PINGSTART
if %errorlevel% equ 3 GOTO EOF

:PINGSTART
cls
echo.
echo.Waiting for %host% to go %mode%..
echo.
echo.Press 1 to stop at any time
echo.
ping %host% -n 1 | findstr /i %status%
if %errorlevel% equ 0 GOTO SUCCESS

choice /c 12 /n /d 2 /t 5 /m "Attempt number %counter%"
if %errorlevel% equ 1 GOTO ASK
if %errorlevel% equ 2 (
set /a counter=%counter%+1
GOTO PINGSTART
)

:SUCCESS
start "" timeout /t 2
if not "%counter%" GEQ "5" (
set /a counter="%counter%"+1
REM THE NEXT FEW LINES ARE A BACKUP IN CASE THE COUNTER GOES OFF THE RAILS. I HAD THIS HAPPEN ONCE AND HAD TO FORCE POWER OFF THE LAPTOP
if not exist %temp%\counter mkdir %temp%\counter
echo.>%temp%\counter\%counter%
if exist %temp%\counter\5 (
if exist %temp%\counter rmdir %temp%\counter /s /q
GOTO GOODJOB
)
start "" timeout /t 1
REM if "%counter%"=="47" powershell [console]::beep^(350,350^)

GOTO SUCCESS
)

:GOODJOB
echo.
start "" timeout /t 1
echo.Good job!
echo.
REM PLAYS THE IMPERIAL MARCH FROM STAR WARS
powershell [console]::beep^(440,500^)      
powershell [console]::beep^(440,500^)
powershell [console]::beep^(440,500^)       
powershell [console]::beep^(349,350^)       
powershell [console]::beep^(523,150^)       
powershell [console]::beep^(440,500^)       
powershell [console]::beep^(349,350^)       
powershell [console]::beep^(523,150^)       
powershell [console]::beep^(440,1000^)
powershell [console]::beep^(659,500^)       
powershell [console]::beep^(659,500^)       
powershell [console]::beep^(659,500^)       
powershell [console]::beep^(698,350^)       
powershell [console]::beep^(523,150^)       
powershell [console]::beep^(415,500^)       
powershell [console]::beep^(349,350^)       
powershell [console]::beep^(523,150^)       
powershell [console]::beep^(440,1000^)


:ASKAGAIN
set counter=
echo.
echo.Did you want to try another host?
echo.
echo.1 - Yes
echo.2 - No
echo.
choice /c 123 /n /d 2 /t 60 /m "Answer: "
if %errorlevel% equ 1 GOTO ASK
if %errorlevel% equ 2 GOTO EOF

:EOF
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=hostping
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
if exist %temp%\counter rmdir %temp%\counter /s /q
exit
