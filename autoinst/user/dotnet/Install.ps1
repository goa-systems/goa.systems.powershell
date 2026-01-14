Set-Location -Path "${PSScriptRoot}"
$DownloadDir = "${env:TEMP}\$(New-Guid)"

if (Test-Path -Path "${DownloadDir}") {
    Remove-Item -Force -Recurse -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

if ( -Not (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Dotnet")) {
    New-Item -ItemType Directory -Path "${env:LOCALAPPDATA}\Programs\Dotnet"
}

$Releases = Invoke-RestMethod -Uri "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/releases-index.json"

$ActiveReleases = New-Object System.Collections.ArrayList

<# Check for actively maintained releases and enable sorting by major version. #>
$Releases.'releases-index' | ForEach-Object {
    if ($_.'support-phase' -eq "active") {
        $ChannelVersion = $_.'channel-version' -split "\."
        $ActiveReleases.Add(@{
                'MajorVersion' = [int] $ChannelVersion[0]
                'SdkVersion'   = $_.'latest-sdk'
            })
    }
}

$ActiveReleases = $ActiveReleases | Sort-Object -Property MajorVersion

$ActiveReleases | ForEach-Object {
    $Url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/$($_.SdkVersion)/dotnet-sdk-$($_.SdkVersion)-win-x64.zip"
    Write-Host -Object "Downloading ${Url}."
    Start-BitsTransfer -Source "${Url}" -Destination "${DownloadDir}"
    Write-Host -Object "Download finished. Extracting."
    Expand-Archive -Force -Path "${DownloadDir}\dotnet-sdk-$($_.SdkVersion)-win-x64.zip" -Destination "${env:LOCALAPPDATA}\Programs\Dotnet"
    Write-Host -Object "Extraction done."
}

Remove-Item -Recurse -Force -Path "${DownloadDir}"