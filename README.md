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

The installer calls shown in this section will ...
* Download the corresponding script into a temporary directory.
* Unblock the file as it is downloaded from the internet.
* Save the current execution policy.
* Set the execution policy to `Unrestricted`.
* Call the script.
* Restore the execution policy to the saved state.
* Remove the temporary directory.

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

This code will install PowerShell 7 on the system. It should be run on a system where PowerShell 7 is not installed and has to be executed in the legacy PowerShell environment.

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

### Git SCM installer

This code will install Git SCM on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/system/gitscm/install.ps1"
Start-BitsTransfer -Source "$StaticUrl" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```
