Set-Location -Path "$PSScriptRoot"
$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
$WorkDir = "$env:LocalAppData\InstSys\kse"
$InstDir = "$env:LocalAppData\Programs\Kse"
Write-Host -Object $Json.version
$Condensed = $Json.version.Replace(".", "")
Write-Host -Object $Condensed
$FileName = "kse-${Condensed}.zip"

if(-not (Test-Path -Path "$WorkDir")){
    New-Item -ItemType Directory -Path "$WorkDir"
}


if(-not (Test-Path -Path "$InstDir")){
    New-Item -ItemType Directory -Path "$InstDir"
}

$BaseUrl = "https://github.com/kaikramer/keystore-explorer/releases/download/v$($Json.version)/$FileName"
Write-Host -Object "Downloading from $BaseUrl"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$BaseUrl" -OutFile "$env:LocalAppData\InstSys\kse\$FileName"
Write-Host -Object "Download done"

Expand-Archive -Path "$env:LocalAppData\InstSys\kse\$FileName" -DestinationPath "$env:LocalAppData\Programs\Kse"