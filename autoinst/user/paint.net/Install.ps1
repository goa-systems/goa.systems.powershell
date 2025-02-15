Set-Location -Path "${PSScriptRoot}"

. "${PSScriptRoot}\..\..\insttools\Installation-Functions.ps1"

$LatestRelease = (Get-LatestRelease -Owner "paintdotnet" -Project "release")

$TagName = $LatestRelease.tag_name
$ZipArchive = ""
$DownloadUrl = ""

$LatestRelease.assets | ForEach-Object {
	if($_.name -match ".*portable\.x64\.zip"){
		$ZipArchive += $_.name
		$DownloadUrl += $_.browser_download_url
	}
}

$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\Paint.NET"
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

New-Item -ItemType "Directory" -Path "${TempDirectory}\extracted"
Expand-Archive -Path "${TempDirectory}\${ZipArchive}" -DestinationPath "${TempDirectory}\extracted"

if( -Not (Test-Path -Path "${ProgramBaseDir}" )) {
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}

Move-Item -Path "${TempDirectory}\extracted" -Destination "${ProgramDir}"

Remove-Item -Recurse -Force -Path "${TempDirectory}"

[System.Environment]::SetEnvironmentVariable("PAINT_NET_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs"

if ( -Not (Test-Path -Path "${FullLinkPath}\Paint.NET.lnk")){
	New-Shortcut -LinkName "Paint.NET" -TargetPath "%PAINT_NET_HOME%\paintdotnet.exe" -Arguments "" -IconFile "%PAINT_NET_HOME%\paintdotnet.exe" -IconId 0 -Description "Paint.NET" -WorkingDirectory "%USERPROFILE%" -ShortcutLocations "${FullLinkPath}"
}