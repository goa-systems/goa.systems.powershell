Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","$PSScriptRoot\uninstall.ps1"
Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","$PSScriptRoot\install.ps1"