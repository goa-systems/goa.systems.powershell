$LatestReleaseUrl = "https://api.github.com/repos/dbeaver/dbeaver/releases/latest"

$TagName = (Invoke-RestMethod -Uri "${LatestReleaseUrl}").tag_name
$FileName = "dbeaver-ce-${TagName}-win32.win32.x86_64.zip"

$DownloadUrl = "https://github.com/dbeaver/dbeaver/releases/download/${TagName}/${FileName}"
$ProgramDir = "${env:LOCALAPPDATA}\Programs\DBeaver"

$TempDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TempDirectory}") {
	Remove-Item -Recurse -Force -Path "${TempDirectory}"
}
New-Item -ItemType "Directory" -Path "${TempDirectory}"

Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDirectory}\${FileName}"
Expand-Archive -Path "${TempDirectory}\${FileName}" -DestinationPath "${TempDirectory}"

if(Test-Path -Path "${ProgramDir}") {
    Get-ChildItem -Path "${ProgramDir}" | ForEach-Object {
	    Remove-Item -Recurse -Force -Path "$($_.FullName)"
    }
}

Get-ChildItem -Path "${TempDirectory}\dbeaver" | ForEach-Object {
    Move-Item -Path "$($_.FullName)"  -Destination "${ProgramDir}"
}

Remove-Item -Recurse -Force -Path "${TempDirectory}"

[System.Environment]::SetEnvironmentVariable("DBEAVER_HOME", "${ProgramDir}", [System.EnvironmentVariableTarget]::User)
$env:DBEAVER_HOME = "${ProgramDir}"

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\DBeaver.lnk"

if ( -Not (Test-Path -Path "${FullLinkPath}")) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("${FullLinkPath}")
    $ShortCut.TargetPath = "%DBEAVER_HOME%\dbeaver.exe"
    $ShortCut.Arguments = "-data `"%USERPROFILE%\workspaces\dbeaver`""
    $ShortCut.WorkingDirectory = "%USERPROFILE%";
    $ShortCut.WindowStyle = 1;
    $ShortCut.Hotkey = "";
    $ShortCut.IconLocation = "%DBEAVER_HOME%\dbeaver.exe, 0";
    $ShortCut.Description = "DBeaver";
    $ShortCut.Save()
}