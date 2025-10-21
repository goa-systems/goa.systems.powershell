function Get-Version {
    $PackagesFile = "https://repo.vivaldi.com/archive/deb/dists/stable/main/binary-amd64/Packages"
    $PackagesInfo = Invoke-WebRequest -Uri "${PackagesFile}"
    $ReadMode = 0
    $PackagesInfo = $PackagesInfo -split '\n'
    $ParsedVersion = ""
    $PackagesInfo | ForEach-Object {
        if ($_ -match 'Package: vivaldi-stable') {
            $ReadMode = 1
        }
        if ($_ -match 'Version: (.*)' -and $ReadMode -eq 1) {
            if ($_ -match 'Version:\s*([\d\.]+)') {
                $Version = $matches[1]
                $ParsedVersion += "${Version}"
            }
        }
    }

    return $ParsedVersion
}

Set-Location -Path "$PSScriptRoot"
$Version = Get-Version
$Setup = "Vivaldi.${Version}.x64.exe"
$DownloadUrl = "https://downloads.vivaldi.com/stable/${Setup}"


$TempDir = "${env:TEMP}\$(New-Guid)"
if (Test-Path -Path "${TempDir}") {
	Remove-Item -Recurse -Force -Path "${TempDir}"
}
New-Item -ItemType "Directory" -Path "${TempDir}"

Write-Host "Downloading from ${DownloadUrl}"
Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDir}\${Setup}"

Start-Process -Wait -FilePath "${TempDir}\${Setup}" -ArgumentList @("--vivaldi-silent", "--do-not-launch-chrome", "--vivaldi-install-dir=`"${env:LOCALAPPDATA}\Programs\Vivaldi`"")
Remove-Item -Recurse -Force -Path "${TempDir}"