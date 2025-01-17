$LatestReleaseUrl = "https://api.github.com/repos/Beep6581/RawTherapee/releases/latest"

$TagName = (Invoke-RestMethod -Uri "${LatestReleaseUrl}").tag_name
$FileName = "RawTherapee_${TagName}_win64_release.zip"

$DownloadUrl = "https://github.com/Beep6581/RawTherapee/releases/download/${TagName}/${FileName}"
$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\RawTherapee"
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
Remove-Item -Path "${TempDirectory}\${FileName}" -Force

if( -Not (Test-Path -Path "${ProgramBaseDir}" )) {
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}
Get-ChildItem -Path "${TempDirectory}" | ForEach-Object {
	Move-Item -Path "$($_.FullName)" -Destination "${ProgramDir}"
}

[System.Environment]::SetEnvironmentVariable("RAWTHERAPEE_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)
Remove-Item -Recurse -Force -Path "${TempDirectory}"