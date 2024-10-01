Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-File","$PSScriptRoot\uninstall.ps1"
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-File","$PSScriptRoot\install.ps1"