Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "powershell.exe" -ArgumentList ".\uninstall.ps1;.\install.ps1"