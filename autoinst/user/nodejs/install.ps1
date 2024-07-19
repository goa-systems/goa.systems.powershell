param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\NodeJS"
)

$Version = (ConvertFrom-Json -InputObject (Get-Content -Raw -Path  "${PSScriptRoot}\version.json")).version
$FileName = "node-$Version-win-x64.zip"
$DownloadUrl = "https://nodejs.org/dist/$Version/$FileName"

$DownloadDir = "$env:TEMP\$(New-Guid)"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Recurse -Force -Path "$DownloadDir"
}
New-Item -ItemType "Directory" -Path "$DownloadDir"

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$DownloadDir\$FileName"

Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$DownloadDir"
Remove-Item -Force -Path "$DownloadDir\$FileName"

Get-ChildItem -Path "$DownloadDir" | ForEach-Object {
	Move-Item -Path $_.FullName -Destination "$InstallDir"
	[System.Environment]::SetEnvironmentVariable("NODEJS_HOME", "$($InstallDir)\$($_.Name)", [System.EnvironmentVariableTarget]::User)
}