Set-Location -Path "${PSScriptRoot}"

. "${PSScriptRoot}\..\..\insttools\Installation-Functions.ps1"

$BackupedConfig = "${env:TEMP}\$(New-Guid).json"

if(Test-Path -Path "${env:IMAGEGLASS_HOME}\igconfig.json"){
	Move-Item -Path "${env:IMAGEGLASS_HOME}\igconfig.json" -Destination "${BackupedConfig}"
}

$LatestRelease = (Get-LatestRelease -Owner "d2phap" -Project "ImageGlass")

$TagName = $LatestRelease.tag_name
$ZipArchive = ""
$DownloadUrl = ""

$LatestRelease.assets | ForEach-Object {
	if($_.name -match ".*x64\.zip"){
		$ZipArchive += $_.name
		$DownloadUrl += $_.browser_download_url
	}
}

$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\ImageGlass"
$ProgramDir = "${ProgramBaseDir}\${TagName}"

if( -Not (Test-Path "${ProgramBaseDir}")){
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

$TempDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TempDirectory}") {
	Remove-Item -Recurse -Force -Path "${TempDirectory}"
}

New-Item -ItemType "Directory" -Path "${TempDirectory}"

Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDirectory}\${ZipArchive}"

Expand-Archive -Path "${TempDirectory}\${ZipArchive}" -DestinationPath "${TempDirectory}"

if( -Not (Test-Path -Path "${ProgramBaseDir}" )) {
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}

Move-Item -Path "${TempDirectory}\ImageGlass_${TagName}_x64" -Destination "${ProgramDir}"

Remove-Item -Recurse -Force -Path "${TempDirectory}"

[System.Environment]::SetEnvironmentVariable("IMAGEGLASS_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs"

if ( -Not (Test-Path -Path "${FullLinkPath}\ImageGlass.lnk")){
	New-Shortcut -LinkName "ImageGlass" -TargetPath "%IMAGEGLASS_HOME%\ImageGlass.exe" -Arguments "" -IconFile "%IMAGEGLASS_HOME%\ImageGlass.exe" -IconId 0 -Description "ImageGlass" -WorkingDirectory "%USERPROFILE%" -ShortcutLocations "${FullLinkPath}"
}

if(Test-Path -Path "${BackupedConfig}"){
	Move-Item -Path "${BackupedConfig}" -Destination "${env:IMAGEGLASS_HOME}\igconfig.json"
}