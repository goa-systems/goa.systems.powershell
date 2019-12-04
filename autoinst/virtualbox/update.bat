@echo off
cd %~dp0
call uninstall.bat --no-exit
call install.bat --no-exit
exit