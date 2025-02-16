Set-Location -Path "$PSScriptRoot"

$InstallDir = "${env:LOCALAPPDATA}\Programs\NodeJS"

. ..\..\insttools\Installation-Functions.ps1

$LatestRelease = Get-LatestRelease -Owner "nodejs" -Project "node"
$LatestVersion = $LatestRelease.tag_name

$FileName = "node-${LatestVersion}-win-x64.zip "
$DownloadUrl = "https://nodejs.org/dist/${LatestVersion}/${FileName}"

$DownloadDir = "$env:TEMP\$(New-Guid)"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Recurse -Force -Path "$DownloadDir"
}
New-Item -ItemType "Directory" -Path "$DownloadDir"

$ProgressPreference = 'SilentlyContinue'
Write-Host -Object "Starting download."
Invoke-WebRequest -Uri "${DownloadUrl}" -OutFile "${DownloadDir}\${FileName}"
Write-Host -Object "Download finished."

Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$InstallDir"

Remove-Item -Recurse -Force -Path "$DownloadDir"

[System.Environment]::SetEnvironmentVariable("NODEJS_HOME", "$($InstallDir)\node-${LatestVersion}-win-x64", [System.EnvironmentVariableTarget]::User)
