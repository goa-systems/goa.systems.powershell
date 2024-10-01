@echo off
CD /D %~dp0
pwsh.exe -ExecutionPolicy Unrestricted -File uninstall.ps1