Set-Location -Path "$PSScriptRoot"
Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","uninstall.ps1"
Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","install.ps1"
