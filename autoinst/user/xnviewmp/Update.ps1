Set-Location -Path "${PSScriptRoot}"
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList @("-File", "Uninstall.ps1")
Start-Process -Wait -FilePath "pwsh.exe" -ArgumentList @("-File", "Install.ps1")