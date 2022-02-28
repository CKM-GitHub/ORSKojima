@echo off
echo ---%date% %time%--->>%cd%\ptk.log
if "%1"=="1" call :_show
if "%1"=="2" call :_action
if "%1"=="" echo No parameter. Exiting.
goto :EOF
 
:_show
del C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\scopeip.log /s /f /q
:: Deleting enabled port:
netsh advfirewall firewall show rule name="Remort Port" >nul
if not ERRORLEVEL 1 (
netsh advfirewall firewall show rule name="Remort Port" | find "RemoteIP:">>C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\scopeip.log
) else (
echo not exist. >>C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\scopeip.log
)
goto :EOF

:_action
del C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\action.log /s /f /q
:: Deleting enabled port:
netsh advfirewall firewall show rule name="Remort Port" >nul
if not ERRORLEVEL 1 (
netsh advfirewall firewall show rule name="Remort Port" | find "Action:">>C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\action.log
) else (
echo notexist>>C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\action.log
)
goto :EOF