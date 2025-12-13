. "${PSScriptRoot}\Functions.ps1"

Install-MiKTeX
Start-Sleep -Seconds 2
Install-MiKTeXPackages
Start-Sleep -Seconds 2
Register-MiKTeX