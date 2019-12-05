@echo off
CD /D %~dp0
Powershell.exe -ExecutionPolicy Unrestricted -File install.ps1