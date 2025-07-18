$LatestReleaseUrl = "https://api.github.com/repos/jgraph/drawio-desktop/releases/latest"
$Response = Invoke-RestMethod -Uri "${LatestReleaseUrl}"
$TagName = $Response.tag_name
$Version = $Response.name
$FileName = "draw.io-${Version}-windows.zip"

$DownloadUrl = "https://github.com/jgraph/drawio-desktop/releases/download/${TagName}/${FileName}"
$ProgramDir = "${env:LOCALAPPDATA}\Programs\Draw.io"

$TempDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TempDirectory}") {
	Remove-Item -Recurse -Force -Path "${TempDirectory}"
}
New-Item -ItemType "Directory" -Path "${TempDirectory}"

Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDirectory}\${FileName}"
Expand-Archive -Path "${TempDirectory}\${FileName}" -DestinationPath "${TempDirectory}"

Move-Item -Path "${TempDirectory}" -Destination "${ProgramDir}"

$FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Draw.io.lnk"

if ( -Not (Test-Path -Path "${FullLinkPath}")) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("${FullLinkPath}")
    $ShortCut.TargetPath = "${ProgramDir}\draw.io.exe"
    $ShortCut.Arguments = ""
    $ShortCut.WorkingDirectory = "%USERPROFILE%";
    $ShortCut.WindowStyle = 1;
    $ShortCut.Hotkey = "";
    $ShortCut.IconLocation = "${ProgramDir}\draw.io.exe, 0";
    $ShortCut.Description = "Draw.io";
    $ShortCut.Save()
}