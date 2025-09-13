Set-Location -Path "${PSScriptRoot}"
$DownloadDir = "${env:TEMP}\$(New-Guid)"
$ProgressPreference = "SilentlyContinue"
if(Test-Path -Path "${DownloadDir}"){
    Remove-Item -Force -Recurse -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

Get-Content -Path "Versions.json" | ConvertFrom-Json | ForEach-Object {
    $Url = "$($_)"
    Start-BitsTransfer -Source "${Url}" -Destination "${DownloadDir}"
}

if(Test-Path -Path "${env:LOCALAPPDATA}\Programs\Dotnet"){
    Get-Process -Name "dotnet" | ForEach-Object {
        Stop-Process -Id $_.Id
    }
    Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\Dotnet"
}

New-Item -ItemType Directory -Path "${env:LOCALAPPDATA}\Programs\Dotnet"

Get-ChildItem -Path "${DownloadDir}" | ForEach-Object {
    Expand-Archive -Force -Path "$($_.FullName)" -Destination "${env:LOCALAPPDATA}\Programs\Dotnet"
}

Remove-Item -Recurse -Force -Path "${DownloadDir}"