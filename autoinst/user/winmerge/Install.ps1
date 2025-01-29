$LatestReleaseUrl = "https://api.github.com/repos/WinMerge/winmerge/releases/latest"

$Response = Invoke-RestMethod -Uri "${LatestReleaseUrl}"
$TagName = $Response.tag_name
$Version = $TagName.Substring(1)
$FileName = "winmerge-${Version}-x64-exe.zip"

$DownloadUrl = "https://github.com/WinMerge/winmerge/releases/download/${TagName}/${FileName}"
$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\WinMerge"
$ProgramDir = "${ProgramBaseDir}\${Version}"

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

[System.Environment]::SetEnvironmentVariable("WINMERGE_HOME","${ProgramDir}", [System.EnvironmentVariableTarget]::User)
Remove-Item -Recurse -Force -Path "${TempDirectory}"