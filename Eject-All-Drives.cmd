@ECHO OFF

REM REVISED 4-24-2020
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
REM FPH IS FOR FUTURE PLACEOLDER IN CASE I ADD MORE PATHS AND CAN EASILY REPLACE THEM IN ALL THE DOCUMENTS AT ONCE
:--------------------------------------
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
if exist C:\Users\daviburt\Toolshed\Toolshed set workdir=C:\Users\daviburt\Toolshed\Toolshed
if exist \\toolshed.corp.amazon.com\share\Windows set workdir=\\toolshed.corp.amazon.com\share
REM FPH
:--------------------------------------


:START

for %%b in (A B C D E F G I J K L M N O P Q R S T U V X Y Z) do if exist %%b: %workdir%\windows\Utilities\removedrive.exe %%b:

if exist %TEMP%\AMAZONIFY\FROMUPDATER GOTO EOFF

set /a counter="%counter%"+1
if %counter%==3 (

if not %counter%==5 GOTO START

:EOF
:-------------------------------------
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=EJECT-THEM-ALL
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

:EOFF
exit
