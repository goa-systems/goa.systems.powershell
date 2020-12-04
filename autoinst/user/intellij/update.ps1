Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "powershell.exe" -ArgumentList "-File","uninstall.ps1" -Wait
Start-Process -FilePath "powershell.exe" -ArgumentList "-File","install.ps1" -Wait
