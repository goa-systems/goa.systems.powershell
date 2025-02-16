Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-Command", ".\Uninstall.ps1;.\Install.ps1") -NoNewWindow