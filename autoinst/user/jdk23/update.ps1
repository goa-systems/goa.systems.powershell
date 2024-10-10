Set-Location -Path "$PSScriptRoot"
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-File","uninstall.ps1"
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList "-File","install.ps1"
