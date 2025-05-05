@ECHO OFF
IF EXIST \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd GOTO EOF
title Deprecated script - Support Engineering Tools
CLS
echo.
ECHO.Hello %username%!
ECHO.
ECHO.These services have been deprecated. 
ECHO.
ECHO.For additional questions or information please email supportengineertools@amazon.com 
ECHO.
ECHO.
TIMEOUT /T 20
EXIT

title Add Follow-Printer - daviburt
cls
set printer1=no
set printer2=no
set counter=1

REM REVISED 9-18-18
REM SETTING WORKING DIRECTORY FOR THIS SCRIPT
:--------------------------------------
if exist \\toolshed\Windows set workdir=\\TOOLSHED
if exist c:\users\public\Toolshed set workdir=c:\users\public\Toolshed
if exist \\ant\dept-na\SFO12_Toolshed\Windows set workdir=\\ant\dept-na\SFO12_Toolshed
if exist \\toolshed.corp.amazon.com\share\Windows set workdir=\\toolshed.corp.amazon.com\share
REM FPH
:--------------------------------------

:START
nslookup localhost | findstr /i "globaldnsanycast.amazon.com" > NUL
IF %ERRORLEVEL% EQU 0 (
cls
echo.
echo.You're on VPN so this may not work..
echo.
echo.
timeout /t 10 > NUL
GOTO PRINTASK
)

:PRINTASK
cls
echo.
echo.Are you attempting to install Global Follow-You Printing?
echo. ^(Also referred to as FYP5^)
echo.
echo.1 - Yes
echo.2 - No
echo.
echo.3 - Quit
echo.
echo.
CHOICE /C 123 /T 30 /N /D 1 /M "Answer:" 
IF %ERRORLEVEL% EQU 1 "%workdir%\Windows\Scripts\Global-FYP\FYP5_INSTALL.CMD"
IF %ERRORLEVEL% EQU 2 GOTO PRINTERADD
IF %ERRORLEVEL% EQU 3 (
set logname=skiplog
GOTO ENDING
)


:PRINTERADD
cls

ipconfig | findstr /i ams10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-ams10-01\ams10-FollowYou
set printer2=\\print-ams10-01\ams10-FollowYou-Color
)

ipconfig | findstr /i ams11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-ams11-01\ams11-FollowYou-Color
set printer2=\\print-ams11-01\arn12-FollowYou
)

ipconfig | findstr /i atl11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-atl11-01\atl11-FollowYou-1

ipconfig | findstr /i atl12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-atl11-01\atl12-FollowYou

ipconfig | findstr /i aus11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-aus11-01\AUS11-FollowYouPrint
set printer2=\\print-aus11-01\AUS13-FollowYou
)

ipconfig | findstr /i ber1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-ber1-11\ber1-FollowYou

ipconfig | findstr /i BER12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BER12-01\BER12-FollowYou

ipconfig | findstr /i BLR1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BLR1-11\BLR1-FollowYou

ipconfig | findstr /i BLR12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BLR12-01\BLR12-FollowYou

ipconfig | findstr /i BLR13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BLR13-01\BLR13-FollowYou

ipconfig | findstr /i BLR14 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BLR14-01\BLR14-FollowYou

ipconfig | findstr /i blr2 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-blr2-11\BLR2-FollowYou

ipconfig | findstr /i blr3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-blr3-12\blr3-FollowYou

ipconfig | findstr /i BNE11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BNE11-12\BNE11-FollowYou

ipconfig | findstr /i BOM13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BOM13-01\BOM13-FollowYou

ipconfig | findstr /i BOM12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BOM12-01\BOM12-fyp-colour

ipconfig | findstr /i bos11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-bos11-11\BOS11-FollowYouColor
set printer2=\\print-bos11-11\BOS11-FollowYouBW
)

ipconfig | findstr /i bos12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-bos12-11\bos12-followyou

ipconfig | findstr /i bos16 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-bos11-11\bos16-FollowYouColor
set printer2=\\print-bos11-11\bos16-FollowYou
)

ipconfig | findstr /i BRS10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-BRS10-01\BRS10-colour-queue

ipconfig | findstr /i cag10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-cag10-01\FollowYou_Color
set printer2=\\print-cag10-01\FollowYou_BW
)

ipconfig | findstr /i CBG10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-CBG10-01\CBG10-FollowYou

ipconfig | findstr /i CDG11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-CDG11-01\CDG11-FollowYou-colour
set printer2=\\PRINT-CDG11-01\CDG11-FollowYou-BW
)

ipconfig | findstr /i CJB10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-CJB10-01\CJB10-FollowYouColor
set printer2=\\PRINT-CJB10-01\CJB10-FollowYouBW
)

ipconfig | findstr /i cpt2 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-cpt2-11\cpt2-FollowYou-colour
set printer2=\\print-cpt2-11\cpt2-FollowYou-Mono
)

ipconfig | findstr /i cts10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-cts10-01\cts10-FollowYou

ipconfig | findstr /i CTU11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-CTU11-01\CTU11-BW-FollowYou

ipconfig | findstr /i ctu2 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-ctu2-01\ctu2-FollowYou

ipconfig | findstr /i dca11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-iad21-11\DCA11-FollowYou

ipconfig | findstr /i DEL10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-DEL10-11\DEL10-FollowYou_Colour
set printer2=\\PRINT-DEL10-11\DEL10-b&w
)

ipconfig | findstr /i DEL12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-DEL12-01\DEL12-FollowYou

ipconfig | findstr /i DEL13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-DEL13-01\DEL13-FollowYou

ipconfig | findstr /i DEL19 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-DEL13-01\DEL19-FollowYou

ipconfig | findstr /i dfw11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-dfw11-01\DFW11-FollowYouPrint

ipconfig | findstr /i dtw10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-dtw10-11\DTW10-FollowYou

ipconfig | findstr /i dub12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-dub12-01\Dub-Black & White

ipconfig | findstr /i ewr1 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-ewr1-01\ewr1-FollowYou-Black&White
set printer2=\\print-ewr1-01\ewr1-FollowYou-colour
)

ipconfig | findstr /i ewr3 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-ewr3-01\ewr3-FollowYouColor
set printer2=\\print-ewr3-01\ewr3-FollowYouBW
)

ipconfig | findstr /i FRA52 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\FRA52-FollowYou

ipconfig | findstr /i FRA53 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\FRA53-FollowYou

ipconfig | findstr /i FRA54 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\FRA54-FollowYou

ipconfig | findstr /i FRA56 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\FRA56-FollowYou

ipconfig | findstr /i FRA60 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\FRA60-FollowYou

ipconfig | findstr /i gdn11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-gdn11-01\gdn11-FollowYou-BW

ipconfig | findstr /i gru10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-gru10-01\GRU10-FollowYou-BW

ipconfig | findstr /i HKG12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-HKG12-01\HKG12-FollowYou-PC

ipconfig | findstr /i hnd10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-hnd10-11\hnd10-FollowYou

ipconfig | findstr /i hts3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-hts3-11\hts3-FollowYou

ipconfig | findstr /i /c:hyd1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-hyd1-01\hyd1-FollowYou

ipconfig | findstr /i /c:hyd2 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-hyd2-11\hyd2-FollowYou

ipconfig | findstr /i /c:hyd10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-hyd10-11\hyd10-FollowYou

ipconfig | findstr /i /c:hyd11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-hyd11-01\hyd11-FollowYou
set printer2=\\print-hyd11-01\hyd11-FollowYouCS
)

ipconfig | findstr /i /c:HYD15 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-HYD15-01\HYD15-FollowYou

ipconfig | findstr /i iad21 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-iad21-11\IAD21-FollowYou

ipconfig | findstr /i ias12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-ias12-01\ias12-followyou

ipconfig | findstr /i ICN11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-ICN11-01\ICN11-followyou

ipconfig | findstr /i jfk14 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-jfk14-01\JFK14-FollowYou

ipconfig | findstr /i kix10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-kix10-11\kix10-FollowYou

ipconfig | findstr /i lax10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lax10-01\lax10-followyou

ipconfig | findstr /i lax16 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lax10-01\lax16-followyou

ipconfig | findstr /i lex11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lex11-11\lex11-followyou

ipconfig | findstr /i lga3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lga3-11\lga10-followyou

ipconfig | findstr /i lga10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lga10-01\lga10-followyou

ipconfig | findstr /i lga13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lga10-01\lga13-followyou

ipconfig | findstr /i LHR10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-LHR10-21\LHR10-colour
set printer2=\\PRINT-LHR10-21\LHR10-bw
)

ipconfig | findstr /i lhr14 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lhr14-01\lhr14-colour-queue
set printer2=\\print-lhr14-01\lhr14-mono-queue
)

ipconfig | findstr /i LHR15 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-LHR15-01\LHR15-colour-queue
set printer2=\\PRINT-LHR15-01\LHR15-mono-queue
)

ipconfig | findstr /i LHR16 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-LHR16-01\LHR16-colour-queue
set printer2=\\PRINT-LHR16-01\LHR16-mono-queue
)

ipconfig | findstr /i lhr17 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lhr17-01\lhr17-colour-queue
set printer2=\\print-lhr17-01\lhr17-mono-queue
)

ipconfig | findstr /i LHR23 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-LHR23-01\LHR23-FollowYou

ipconfig | findstr /i lin11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lin11-01\lin11-followyou-colour
set printer2=\\print-lin11-01\lin11-followyou-bw
)

ipconfig | findstr /i lux4 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lux4-a1\LUX4-Print colour
set printer2=\\print-lux4-a1\LUX4-Print B&W
)

ipconfig | findstr /i LUX4 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-LUX4-A1\LUX12-Print Colour
set printer2=\\PRINT-LUX4-A1\LUX12-Print B&W
)

ipconfig | findstr /i lux5 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lux5-03\LUX5-Print Colour
set printer2=\\print-lux5-03\LUX5-Print B&W
)
ipconfig | findstr /i lux6 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lux5-03\LUX5-Print B&W

ipconfig | findstr /i lux7 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lux5-03\LUX5-Print B&W

ipconfig | findstr /i lux10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lux5-03\LUX5-Print B&W

ipconfig | findstr /i lux11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lux5-03\LUX5-Print B&W

ipconfig | findstr /i lux12 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-lux12-01\LUX12-Print B&W
set printer2=\\print-lux12-01\LUX12-Print Colour
)

ipconfig | findstr /i lux13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lux12-01\LUX12-Print B&W

ipconfig | findstr /i LUX19 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-LUX19-01\LUX12-Print Colour
set printer2=\\PRINT-LUX19-01\LUX12-Print B&W
)

ipconfig | findstr /i maa2 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-maa3-01\print-in-maa-color-fyp
set printer2=\\print-maa3-01\print-in-maa-fyp
)

ipconfig | findstr /i maa3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-maa3-01\print-in-maa-fyp

ipconfig | findstr /i MAD12 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-MAD12-01\MAD-followyou-colour
set printer2=\\PRINT-MAD12-01\MAD-followyou-bw
)

ipconfig | findstr /i MEL11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MEL11-01\MEL11-FollowYou

ipconfig | findstr /i mex13 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-mex13-02\mex13FollowYouCOLOR
set printer2=\\print-mex13-02\mex13FollowYouBW
)

ipconfig | findstr /i MRY11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MRY11-01\MRY11-FollowYou

ipconfig | findstr /i msn4 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-MSN4-01\MSN4-FollowYou

ipconfig | findstr /i msp12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-MSN4-01\msp12-FollowYou

ipconfig | findstr /i msp14 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-MSN4-01\msp14-FollowYou

ipconfig | findstr /i MUC2 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\MUC2-FollowYou

ipconfig | findstr /i MUC3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-MUC2-A1\MUC3-FollowYou

ipconfig | findstr /i ORD10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-ORD10-01\MAD-followyoucolor
set printer2=\\PRINT-ORD10-01\MAD-followyou
)

ipconfig | findstr /i ork1 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-ork1-11\MAD-followyou_colour
set printer2=\\print-ork1-11\MAD-followyou
)

ipconfig | findstr /i pek2 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-pek2-01\PEK2-FollowYou

ipconfig | findstr /i pek10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-pek10-01\pek10-FollowYou

ipconfig | findstr /i pek12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-pek12-01\pek12-FollowYou

ipconfig | findstr /i phx10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-phx10-11\PHX10-FollowYou

ipconfig | findstr /i PNQ10 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-PNQ10-01\PNQ10-FollowYou Colour
set printer2=\\PRINT-PNQ10-01\PNQ10-FollowYou B&W
)

ipconfig | findstr /i PNQ11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-PNQ11-01\PNQ11-FollowYou
set printer2=\\PRINT-PNQ11-01\PNQ11-B&W-printer
)

ipconfig | findstr /i /c:PRG10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-PRG10-01\PRG10-followyou

ipconfig | findstr /i /c:psc1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-psc1-03\psc1-followyou

ipconfig | findstr /i rba1 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-rba1-12\rba1-fyp-color
set printer2=\\print-rba1-12\rba1-fyp-B&W
)

ipconfig | findstr /i san15 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-lax10-01\san15-FollowYou

ipconfig | findstr /i /c:SBP1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SBP1-03\SBP1-FollowYou

ipconfig | findstr /i /c:sdj10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=print-sdj10-11\sdj10-FollowYou

ipconfig | findstr /i /c:SBP10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SBP1-03\SBP10-FollowYou

ipconfig | findstr /i /c:sfo1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sfo1-03\SFO10-FollowYou

ipconfig | findstr /i sfo10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sfo10-01\SFO10-FollowYou

ipconfig | findstr /i sfo12 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SFO12-02\A9-FollowYou

ipconfig | findstr /i sfo13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sfo13-11\SFO13-FollowYou

ipconfig | findstr /i sfo18 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-sfo18-01\sfo18-followyou
set printer2=\\print-sfo18-01\sfo18-followyouPC
)

ipconfig | findstr /i sfo23 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc3-01\SFO23-FollowYou

ipconfig | findstr /i sfo29 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc3-01\SFO29-FollowYou

ipconfig | findstr /i SHA11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SHA11-01\SHA11-FollowYou

ipconfig | findstr /i SIN11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SIN11-01\SIN11-FollowYou

ipconfig | findstr /i /c:sjc1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc3-01\SJC3-FollowYou

ipconfig | findstr /i /c:sjc3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc3-01\SJC3-FollowYou

ipconfig | findstr /i /c:sjc4 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc3-01\SJC3-FollowYou

ipconfig | findstr /i sjc10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc11-01\LAB126-FollowYou

ipconfig | findstr /i sjc11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc11-01\LAB126-FollowYou

ipconfig | findstr /i sjc13 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc11-01\LAB126-FollowYou

ipconfig | findstr /i sjc15 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\print-sjc15-01\SJC15-FollowYou-Color
set printer2=\\print-sjc15-01\SJC15-FollowYou
)

ipconfig | findstr /i sjc18 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjc18-01\SJC18-FollowYou-PC

ipconfig | findstr /i /c:sjo1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-cas-sjo1\sjo1-followyou

ipconfig | findstr /i SJO3 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-SJO3-11\SJO3-Followyou

ipconfig | findstr /i sjo10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sjo10-02\SJO10-Followyou

ipconfig | findstr /i sna > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sna11-01\SNA-FollowYou

ipconfig | findstr /i /c:sna14 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-sna11-01\sna14-FollowYou

ipconfig | findstr /i SYD12 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-SYD12-01\SYD12-FollowYou-colour
set printer2=\\PRINT-SYD12-01\SYD12-FollowYou
)

ipconfig | findstr /i SZX13 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-SZX13-01\SZX13-FollowYou-color
set printer2=\\PRINT-SZX13-01\SZX13-FollowYou
)

ipconfig | findstr /i SZX2 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-SZX2-01\SZX2-FollowYou-color
set printer2=\\PRINT-SZX2-01\SZX2-FollowYou
)

ipconfig | findstr /i TPE11 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\PRINT-TPE11-01\TPE11-FollowYou

ipconfig | findstr /i tsn10 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-tsn10-11\tsn10-FollowYou

ipconfig | findstr /i txl1 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-txl1-11\txl1-FollowYou

ipconfig | findstr /i yvr11 > NUL
IF %ERRORLEVEL% EQU 0 (
set printer1=\\PRINT-VVR11-01\YVR11-FollowYouColor
set printer2=\\PRINT-VVR11-01\YVR11-YVR11-FollowYouBW
)

ipconfig | findstr /i yyz14 > NUL
IF %ERRORLEVEL% EQU 0 set printer1=\\print-yyz14-01\YYZ14-FollowYouPrint

set logname=skiplog
start /min /wait "" "%workdir%\Windows\Scripts\Global-FYP\FYP5_INSTALL.CMD"
set logname=

if %printer1%==no GOTO GIVEUP

:REMOVEPRINT
wmic printer get name /value | findstr /i "%printer1%" > NUL
IF %ERRORLEVEL% EQU 0 (
echo.
echo.Attempting to remove the printer for this site..
echo.
echo.%printer1%
echo.
echo.
timeout /t 5 > NUL
rundll32 printui.dll,PrintUIEntry /dn /q /n %printer1%
GOTO ADDPRINT
)

IF %ERRORLEVEL% EQU 1 (
timeout /t 3 > NUL
)

if %printer1%==no GOTO GIVEUP

:ADDPRINT
set counter=1
:POSTADD
if %printer1%==no GOTO GIVEUP
cls
echo.
echo.
echo.Attempt %counter% of 5 to install the printer..
echo.
echo.
echo.%printer1%
echo.
timeout /t 5 > NUL
echo.Set WshNetwork = CreateObject("WScript.Network") > %temp%\printadd.vbs
echo.On Error Resume Next >> %temp%\printadd.vbs
echo.Set WshShell = CreateObject("WScript.Shell") >> %temp%\printadd.vbs
if "%logname%"=="" echo.WshShell.Exec("control printers") >> %temp%\printadd.vbs
echo.WshNetwork.RemovePrinterConnection "%printer1%" >> %temp%\printadd.vbs
echo.WshNetwork.RemovePrinterConnection "%printer1%" >> %temp%\printadd.vbs
if not %printer2%==no echo.WshNetwork.RemovePrinterConnection "%printer2%" >> %temp%\printadd.vbs
echo.WshNetwork.AddWindowsPrinterConnection "%printer1%" >> %temp%\printadd.vbs
if not %printer2%==no echo.WshNetwork.AddWindowsPrinterConnection "%printer2%" >> %temp%\printadd.vbs
echo.WshNetwork.SetDefaultPrinter "%printer1%" >> %temp%\printadd.vbs
echo.WshNetwork.SetDefaultPrinter "%printer1%" >> %temp%\printadd.vbs
cscript %temp%\printadd.vbs
timeout /t 10 /nobreak > NUL
wmic printer get name /value | findstr /i "%printer1%" > NUL
IF %ERRORLEVEL% EQU 1 (
IF %counter%==5 GOTO GIVEUP
set /a counter=%counter%+1
GOTO POSTADD
)
echo.
echo.
echo.Verifying default printer setup..
echo.
echo.
timeout /t 3 > NUL
wmic printer get name,default | findstr /i %printer1% | findstr /i true > NUL
if %errorlevel% equ 1 RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "%printer1%" > NUL

GOTO EOF

:GIVEUP
cls
echo.
echo.Not able to install the printer.
echo.
echo.%printer1%
echo.
echo. Try adding the printer manully.. or reboot and try again..
echo.
echo.or Let daviburt@ know to add your site.
echo.
ipconfig | findstr /i "Connection-specific" | findstr /i /c:".amazon.com" > %temp%\results.txt
for /f "tokens=6" %%a in (%temp%\results.txt) do set SC=%%a > NUL
set SC=%SC:~0,5%
"%workdir%\Windows\Utilities\Blat\blat" -to toolshed-feedback@amazon.com -server mail-relay.amazon.com -f %username%@amazon.com -subject "Printer Adding Attempt" -body "%computername%-%SC%" > NUL
timeout /t 10 > NUL

if exist %temp%\Newhire GOTO EOFF
if "%logname%"=="" control /name Microsoft.DevicesAndPrinters

:EOF
CLS
set checkdir=
:-------------------------------------
if /i [%logname%]==[SKIPLOG] GOTO EOFF
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd (
if /i not [%logname%]==[NOLOG] set logname=FYP
if exist \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd \\toolshed.corp.amazon.com\share\Counts4Daviburt\SET.cmd
EXIT
start /wait "" \\toolshed.corp.amazon.com\share\Counts4Daviburt\Scripts\Createlog.cmd
)
:-------------------------------------

type \\toolshed.corp.amazon.com\share\Counts4Daviburt\Exclude.txt | findstr /i %computername% > NUL
if %errorlevel% equ 1 start /min "" net localgroup administrators fs-toolshed-it /del > NUL
:EOFF
exit
