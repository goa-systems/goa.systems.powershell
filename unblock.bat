@echo off

powershell.exe -ExecutionPolicy Unrestricted -Command "Get-ChildItem -Path "." -Recurse | Where-Object {$_.Name -match """(.*)\.ps1"""} | Foreach-Object {Write-Host "Unblocking $($_.FullName)"; Unblock-File -Path "$($_.FullName)"}"