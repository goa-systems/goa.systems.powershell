# PowerShell

## About

This project offers a few useful powershell scripts. I am trying to sort them as good as possible and document them in this and other .md files.

## Content

### autoinst

This folder contains automated installation scripts for tools I currently use.

**Some tools require 7z.exe to be avaialable for performat Zip extraction. It is recommended to install "PeaZip" first to make this available.**

### tools

This folder contains PowerShell tools and scripts used for various purposes. Each script is documented by using a README.md file in each folder.

## Specials

### Eclipse installer

The Eclipse installer downloads the basic package and a defined Java environment. Eclipse is started to install the required packages in the latest versions from the package repositories.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/eclipse/install.ps1"
Start-BitsTransfer -Source "$StaticUrl" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### RustDesk installer

This code will install RustDesk remote desktop software on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/system/rustdesk/Install.ps1"
Start-BitsTransfer -Source "$StaticUrl" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### PowerShell 7 installer

This code will install PowerShell 7 on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/system/powershell/Install.ps1"
Start-BitsTransfer -Source "$StaticUrl" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```