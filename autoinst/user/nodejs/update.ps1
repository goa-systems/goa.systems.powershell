Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-Command", ".\uninstall.ps1;.\install.ps1") -NoNewWindow