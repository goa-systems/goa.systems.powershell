@echo off
CD /D %~dp0
call uninstall.bat --no-exit
call install.bat --no-exit
exit