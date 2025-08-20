$FileName = "XnViewMP-win-x64.zip"
$DownloadLink = "https://download.xnview.com/${FileName}"
$TemporaryDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TemporaryDirectory}"){
    Remove-Item -Recurse -Force -Path "${TemporaryDirectory}"
}
New-Item -ItemType "Directory" -Path "${TemporaryDirectory}"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "${DownloadLink}" -OutFile "${TemporaryDirectory}\${FileName}"

if(Test-Path -Path "${env:LOCALAPPDATA}\Programs\XnViewMP"){
    Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\XnViewMP"
}

Expand-Archive -Path "${TemporaryDirectory}\${FileName}" -DestinationPath "${env:LOCALAPPDATA}\Programs"

$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut("${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\XnViewMP.lnk")
$ShortCut.TargetPath = "%LOCALAPPDATA%\Programs\XnViewMP\xnviewmp.exe"
$ShortCut.Arguments = ""
$ShortCut.WorkingDirectory = "%USERPROFILE%";
$ShortCut.WindowStyle = 1;
$ShortCut.Hotkey = "";
$ShortCut.IconLocation = "%LOCALAPPDATA%\Programs\XnViewMP\xnviewmp.exe, 0";
$ShortCut.Description = "Eclipse IDE";
$ShortCut.Save()

Remove-Item -Recurse -Force -Path "${TemporaryDirectory}"