Set-Location -Path "$PSScriptRoot"

. ..\..\insttools\Installation-Functions.ps1
$LatestVersion = Get-LatestRelease -Owner "keepassxreboot" -Project "keepassxc"

$Version = $LatestVersion.tag_name
$DownloadDir = "$env:TEMP\$(New-Guid)"
$InstallDir = "$env:LOCALAPPDATA\Programs\KeePassXC"
$FileName = "KeePassXC-${Version}-Win64.zip"
$Url = "https://github.com/keepassxreboot/keepassxc/releases/download/$Version/$FileName"

if(Test-Path -Path "$DownloadDir"){
	Write-Host -Object "Removing existing download directory ${DownloadDir}."
	Remove-Item -Recurse -Force -Path "$DownloadDir"
}
New-Item -ItemType "Directory" -Path "$DownloadDir"

$ProgressPreference = 'SilentlyContinue'
Write-Host -Object "Downloading ${Url} to ${DownloadDir}\${FileName}"
Invoke-WebRequest -Uri "${Url}" -OutFile "${DownloadDir}\${FileName}"
Write-Host -Object "Download done"

if(-Not (Test-Path -Path "${InstallDir}")){
	New-Item -ItemType "Directory" -Path "${InstallDir}"
}

Expand-Archive -Path "${DownloadDir}\${FileName}" -DestinationPath "${InstallDir}"

$ArrayList = [System.Collections.ArrayList]::new()
Get-ChildItem -Path "${InstallDir}" | ForEach-Object {
	$ArrayList.Add($_.FullName)
}
$HomeDir = $ArrayList[-1]

[System.Environment]::SetEnvironmentVariable("KEEPASSXC_HOME", "${HomeDir}", [System.EnvironmentVariableTarget]::User)

Remove-Item -Recurse -Force -Path "$DownloadDir"

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\KeePassXC.lnk"

if ( -Not (Test-Path -Path "${FullLinkPath}")){
	New-Shortcut -LinkName "KeePassXC" -TargetPath "%KEEPASSXC_HOME%\KeePassXC.exe" -Arguments "--config `"%APPDATA%\KeePassXC\keepassxc.ini`" --localconfig `"%APPDATA%\KeePassXC\keepassxc_local.ini`"" -IconFile "%KEEPASSXC_HOME%\KeePassXC.exe" -IconId 0 -Description "KeePassXC" -WorkingDirectory "%USERPROFILE" -ShortcutLocations "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs"
}