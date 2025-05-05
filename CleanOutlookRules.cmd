@echo off
cls

title Outlook Rule Cleaner

REM VARIABLE FOR THE CONFIRMOPEN FUNCTION
set counter=0

REM MENU TO ASK FOR OUTLOOK TO BE CLOSED
:CONFIRMCLOSE
cls
echo.
echo.This is primarily for those who have issues opening the 'Rules' section of their Outlook
echo.or are unable to delete any existing rules.
echo.
echo.If you are not experiencing these symptoms backup your rules first!
echo.
echo.
echo.This requires Outlook to be closed because it WILL DELETE
echo.any rules that require Outlook to be open to run!
echo.
echo.All the rules that run on the Exchange E-mail servers will be safe.
echo.
echo.
echo.1 - It's closed now
echo.2 - Close it for me
echo.
echo.3 - How do I backup my rules?
echo.
echo.4 - Quit
echo.
echo.
choice /c 1234 /n /d 4 /t 60 /m Answer: 
if %errorlevel% equ 1 GOTO CONFIRMCLOSED
if %errorlevel% equ 2 taskkill /f /im Outlook* > NUL
if %errorlevel% equ 3 (
start microsoft-edge:https://www.howtogeek.com/240673/how-to-export-and-import-rules-in-outlook/
timeout /t 15 > NUL
GOTO CONFIRMCLOSE
)
if %errorlevel% equ 4 GOTO EOF

REM CONFIRMS THAT OUTLOOK IS CLOSED AND IF NOT RETURNS TO THE PREVIOUS FUNCTION
:CONFIRMCLOSED
cls
tasklist | findstr /i outlook > NUL
if %errorlevel% equ 0 (
cls
echo.
echo.Outlook appears to be open still..
echo.
echo.
timeout /t 5
GOTO CONFIRMCLOSE
)
if %errorlevel% equ 1 GOTO CLEANRULES

REM RUNS OUTLOOK WITH THE CLEANRULES SWITCH TO RESOLVE OUTLOOK RULE ISSUES
:CLEANRULES
cls
echo.
echo.Opening Outlook with clean rules..
echo.
echo.Press ctrl+c to cancel this if you think you need to backup your Outlook rules first.
echo.
echo.
timeout /t 15 /nobreak
start "" outlook.exe /cleanclientrules

REM CONFIRMS THAT OUTLOOK OPEN WITH THE SWITCH FROM THE CLEANRULES FUNCTION
:CONFIRMOPEN
timeout /t 5 > NUL
tasklist | findstr /i outlook > NUL
if %errorlevel% equ 0 GOTO EOF
if %errorlevel% equ 1 (
if not "%counter%"=="5" (
set /a counter="%counter%+1"
GOTO CONFIRMOPEN
)
)

REM IF THE SCRIPT IS UNABLE TO OPEN OUTLOOK FOR THEM IT TELLS THEM HOW TO DO IT MANUALLY
:OPENMANUALLY
cls
echo.
echo.I'm unable to open Outlook for you.
echo.
echo.Please run this command to clean your Outlook rules manully to hopefully resolve the issue you're facing.
echo.
echo.
echo.outlook.exe ^/cleanclientrules
echo.
timeout /t 30

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=CLEANOUTLOOKRULES
start "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
EXIT
