@echo off
cls
echo.
echo.If this fails to load then this machine is probably already enrolled..
echo.
echo.
timeout /t 7
if exist C:\Windows\CCM\SCClient.exe C:\Windows\CCM\SCClient.exe softwarecenter:SoftwareID=ScopeId_6C900AD6-A53B-4C44-B96C-1002E20C5DF9/Application_797fa1e2-c981-41cf-8e69-602eb902fc5c
if exist C:\WINDOWS\CCM\ClientUX\SCClient.exe C:\WINDOWS\CCM\ClientUX\SCClient.exe softwarecenter:SoftwareID=ScopeId_6C900AD6-A53B-4C44-B96C-1002E20C5DF9/Application_797fa1e2-c981-41cf-8e69-602eb902fc5c
start /min "" gpupdate /force /wait:0