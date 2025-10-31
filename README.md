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

### Java installer

The Java installer will download Azul OpenJDK packages and install them into `%LOCALAPPDATA%\Programs\Java` and create an environment variable for each Java distribution in the form of `%JAVA_HOME_N%`

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/jdk/Functions.ps1"
Start-BitsTransfer -Source "$StaticUrl" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\Functions.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
. "${TempDirectory}\Functions.ps1"
Write-Host "Installing Java versions and setting `%JAVA_HOME%` to the latest version."
Install-JavaVersions -SetJavaHomeToLatest
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### Gradle installer

The Gradle installer installs Gradle in `%LOCALAPPDATA%\Programs\Gradle\gradle-<version>` where `<version>` represents the latest version.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/gradle/install.ps1"
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

### Libreoffice installer

This code will install Libreoffice on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/system/libreoffice"
Start-BitsTransfer -Source "${StaticUrl}/install.ps1" -Destination "${TempDirectory}"
Start-BitsTransfer -Source "${StaticUrl}/uninstall.ps1" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
Unblock-File -Path "${TempDirectory}\uninstall.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\uninstall.ps1"
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### Firefox installer

This code will install Firefox for the current user on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/firefox/install.ps1"
Start-BitsTransfer -Source "${StaticUrl}" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### OBS Studio installer

This code will install Firefox for the current user on the system.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
$StaticUrl = "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/obsstudio/Install.ps1"
Start-BitsTransfer -Source "${StaticUrl}" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```

### Java installer

This code will install JDK packages for the current user on the system. This will install current and LTS packages into `%LOCALAPPDATA%\Programs\Java` and set `%JAVA_HOME_VERSION%` variables pointing to these locations.

```powershell
$TempDirectory = "${env:TEMP}\$(New-Guid)"
New-Item -ItemType "Directory" -Path "${TempDirectory}"
Start-BitsTransfer -Source "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/jdk/Functions.ps1" -Destination "${TempDirectory}"
Start-BitsTransfer -Source "https://raw.githubusercontent.com/goa-systems/goa.systems.powershell/refs/heads/main/autoinst/user/jdk/Install.ps1" -Destination "${TempDirectory}"
Unblock-File -Path "${TempDirectory}\Functions.ps1"
Unblock-File -Path "${TempDirectory}\Install.ps1"
$ExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
& "${TempDirectory}\Install.ps1"
Set-ExecutionPolicy -ExecutionPolicy $ExecutionPolicy -Scope CurrentUser -Force
Remove-Item -Recurse -Force -Path "${TempDirectory}"
Write-Host -Object "Done"

```


