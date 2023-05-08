Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList ".\uninstall.ps1" -Wait
Start-Process -FilePath "pwsh.exe" -ArgumentList ".\install.ps1" -Wait