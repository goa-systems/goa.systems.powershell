Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList "-File","uninstall.ps1" -Wait
Start-Process -FilePath "pwsh.exe" -ArgumentList "-File","install.ps1" -Wait
