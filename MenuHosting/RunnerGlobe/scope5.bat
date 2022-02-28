@echo off
set str=%1
del %cd%\session.log /s /f /q
::for /f "tokens=1 delims= " %i in ('query user ^| findstr /i "active"') do %i
QUERY user>>%c%\session.log
::quser>>%cd%\session.log
EXIT /B