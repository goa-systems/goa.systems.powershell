Set-Location "$PSScriptRoot"
$Json = Get-Content -Path "version.json" | ConvertFrom-Json
$Url = "https://dist.nuget.org/win-x86-commandline/$($Json.version)/nuget.exe"

Write-Host "$Url"

$InstDir = "$env:LocalAppdata\Programs\NuGet\$($Json.version)"

if(Test-Path "$InstDir") {
    Remove-Item -Recurse -Force -Path "$Instdir"
}
New-Item -ItemType "Directory" -Path "$InstDir"

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$Url" -OutFile "$InstDir\nuget.exe"

[System.Environment]::SetEnvironmentVariable("NUGET_HOME", "$InstDir", [System.EnvironmentVariableTarget]::User)