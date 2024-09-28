$Json = (Get-Content -Path "${PSScriptRoot}\version.json" | ConvertFrom-Json)
$FileName = "dbeaver-ce-$($Json.version)-win32.win32.x86_64.zip"
$DownloadUrl = "https://github.com/dbeaver/dbeaver/releases/download/$($Json.version)/${FileName}"
$ProgramBaseDir = "${env:LOCALAPPDATA}\Programs\DBeaver"
$ProgramDir = "${ProgramBaseDir}\$($Json.version)"

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

Set-ItemProperty -Path "HKCU:\Environment" -Name "DBEAVER_HOME" -Type ExpandString -Value "%LOCALAPPDATA%\\Programs\DBeaver\$($Json.version)"