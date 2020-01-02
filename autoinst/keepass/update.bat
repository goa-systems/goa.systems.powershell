@echo off
CD /D %~dp0
call uninstall.bat
call install.bat
exit