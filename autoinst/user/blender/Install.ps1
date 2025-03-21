$Tags = Invoke-RestMethod -Uri "https://api.github.com/repos/blender/blender/tags"

$Version = $Tags[0].name.Substring(1)
$Major = $Version -split "\."
$Url = "https://mirrors.dotsrc.org/blender/release/Blender$($Major[0]).$($Major[1])/blender-${Version}-windows-x64.zip"
$InstallDir = "${env:LOCALAPPDATA}\Programs\Blender"

$TemporaryDirectory = "${env:TEMP}\$(New-Guid)"
if(Test-Path -Path "${TemporaryDirectory}"){
    Remove-Item -Recurse -Force -Path "${TemporaryDirectory}"
}
New-Item -ItemType "Directory" -Path "${TemporaryDirectory}"

Start-BitsTransfer -Source "${Url}" -Destination "${TemporaryDirectory}"

if(-Not (Test-Path -Path "${InstallDir}")){
    New-Item -ItemType "Directory" -Path "${InstallDir}"
}

Get-ChildItem -Path "${TemporaryDirectory}" | ForEach-Object {
    Expand-Archive -Path "$($_.FullName)" -DestinationPath "${InstallDir}"
}

if ( -Not (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Blender.lnk")) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Blender.lnk")
    $ShortCut.TargetPath = "`"%BLENDER_HOME%\blender-launcher.exe`""
    $ShortCut.Arguments = ""
    $ShortCut.WorkingDirectory = "%USERPROFILE%";
    $ShortCut.WindowStyle = 1;
    $ShortCut.Hotkey = "";
    $ShortCut.IconLocation = "%BLENDER_HOME%\blender-launcher.exe, 0";
    $ShortCut.Description = "Blender";
    $ShortCut.Save()
}

[System.Environment]::SetEnvironmentVariable("BLENDER_HOME","${InstallDir}\blender-${Version}-windows-x64", [System.EnvironmentVariableTarget]::User)

Remove-Item -Recurse -Force -Path "${TemporaryDirectory}"