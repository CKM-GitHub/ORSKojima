del %cd%\users.log /s /f /q
::netstat -n | find ":3389" | find "ESTABLISHED">>%cd%\users.log
::more %cd%\users.log
netstat -n>>%cd%\users.log
::netstat -n>>C:\SMS\InetGlobe\Web\Publish\RunnerGlobe\users.log
Exit /b