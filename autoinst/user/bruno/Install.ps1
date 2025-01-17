$LatestReleaseUrl = "https://api.github.com/repos/usebruno/bruno/releases/latest"

$Response = Invoke-RestMethod -Uri "${LatestReleaseUrl}"
$TagName = $Response.tag_name
$Version = $TagName.Substring(1)
$FileName = "bruno_${Version}_x64_win.zip"

$DownloadUrl = "https://github.com/usebruno/bruno/releases/download/${TagName}/${FileName}"
$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\Bruno"
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

Remove-Item -Path "${TempDirectory}\${FileName}"

if( -Not (Test-Path -Path "${ProgramBaseDir}" )) {
	New-Item -ItemType "Directory" -Path "${ProgramBaseDir}"
}

if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}
Get-ChildItem -Path "${TempDirectory}" | ForEach-Object {
	Move-Item -Path "$($_.FullName)" -Destination "${ProgramDir}"
}

[System.Environment]::SetEnvironmentVariable("BRUNO_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)
Remove-Item -Recurse -Force -Path "${TempDirectory}"