. "${PSScriptRoot}\..\..\insttools\Installation-Functions.ps1"

$LatestReleaseUrl = "https://api.github.com/repos/dbeaver/dbeaver/releases/latest"

$TagName = (Invoke-RestMethod -Uri "${LatestReleaseUrl}").tag_name
$FileName = "dbeaver-ce-${TagName}-win32.win32.x86_64.zip"

$DownloadUrl = "https://github.com/dbeaver/dbeaver/releases/download/${TagName}/${FileName}"
$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\DBeaver"
$ProgramDir = "${ProgramBaseDir}\${TagName}"

if( -Not (Test-Path "${ProgramBaseDir}")){
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

$TempDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TempDirectory}") {
	Remove-Item -Recurse -Force -Path "${TempDirectory}"
}

New-Item -ItemType "Directory" -Path "${TempDirectory}"

Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDirectory}\${FileName}"

Expand-Archive -Path "${TempDirectory}\${FileName}" -DestinationPath "${TempDirectory}"

if( -Not (Test-Path -Path "${TempDirectory}" )) {
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}

Move-Item -Path "${TempDirectory}\dbeaver" -Destination "${ProgramDir}"

Remove-Item -Recurse -Force -Path "${TempDirectory}"

# Set-ItemProperty -Path "HKCU:\Environment" -Name "DBEAVER_HOME" -Type ExpandString -Value "%LOCALAPPDATA%\\Programs\DBeaver\$($Json.version)"
[System.Environment]::SetEnvironmentVariable("DBEAVER_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\DBeaver.lnk"

if ( -Not (Test-Path -Path "${FullLinkPath}")){
	New-Shortcut -LinkName "WinMerge" -TargetPath "%DBEAVER_HOME%\dbeaver.exe" -Arguments "" -IconFile "%DBEAVER_HOME%\dbeaver.exe" -IconId 0 -Description "DBeaver" -WorkingDirectory "%USERPROFILE" -ShortcutLocations "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs"
}