Set-Location -Path "$PSScriptRoot"
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\uninstall.ps1") -Wait
Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\install.ps1") -Wait