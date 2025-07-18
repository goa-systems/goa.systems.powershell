Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Uninstall.ps1") -Wait
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Install.ps1") -Wait