Set-Location -Path "${PSScriptRoot}"
$DownloadDir = "${env:TEMP}\$(New-Guid)"

if(Test-Path -Path "${DownloadDir}"){
    Remove-Item -Force -Recurse -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

if( -Not (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Dotnet")){
    New-Item -ItemType Directory -Path "${env:LOCALAPPDATA}\Programs\Dotnet"
}

@("LTS", "STS") | ForEach-Object {
    $Version = Invoke-WebRequest -Uri "https://builds.dotnet.microsoft.com/dotnet/Sdk/$($_)/latest.version"
    $Url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/${Version}/dotnet-sdk-${Version}-win-x64.zip"
    Write-Host -Object "Downloading ${Url}."
    Start-BitsTransfer -Source "${Url}" -Destination "${DownloadDir}"
    Write-Host -Object "Download finished. Extracting."
    Expand-Archive -Force -Path "${DownloadDir}\dotnet-sdk-${Version}-win-x64.zip" -Destination "${env:LOCALAPPDATA}\Programs\Dotnet"
    Write-Host -Object "Extraction done."
}

Remove-Item -Recurse -Force -Path "${DownloadDir}"