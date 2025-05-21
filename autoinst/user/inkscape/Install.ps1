$TagList = Invoke-RestMethod -Uri "https://gitlab.com/api/v4/projects/3472737/repository/tags"
$Version = "$($TagList[0].name)".Substring("INKSCAPE_".Length).Replace("_", ".")
$Uri = "https://inkscape.org/release/inkscape-${Version}/windows/64-bit/compressed-7z/dl/"
$Page = (Invoke-WebRequest -Uri "${Uri}").ToString()
$Pattern = "<a href=`"(.*)`">click here</a>"
$Page -match $Pattern
$RelativeLink = $matches[1]

$DownloadUrl = "https://inkscape.org${RelativeLink}"
$DownloadDir = "${env:TEMP}\$(New-Guid)"

if (Test-Path -Path "${DownloadDir}") {
    Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${DownloadDir}"

Get-ChildItem -Path "${DownloadDir}" | ForEach-Object {
    if (Test-Path -Path "${env:ProgramFiles}\7-Zip") {
        $env:PATH = "${env:ProgramFiles}\7-Zip;${env:PATH}"
    }
    try { 7z | Out-Null } catch {}
    if ($?) {
        Start-Process -FilePath "7z.exe" -ArgumentList "x", "-o`"${DownloadDir}`"", "`"$($_.FullName)`"" -Wait -NoNewWindow
        if (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Inkscape") {
            Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\Inkscape"
        }
        Move-Item -Path "${DownloadDir}\inkscape" -Destination "${env:LOCALAPPDATA}\Programs\Inkscape"
        Remove-Item -Recurse -Force -Path "${DownloadDir}"
        
        [System.Environment]::SetEnvironmentVariable("INKSCAPE_HOME", "${env:LOCALAPPDATA}\Programs\Inkscape", [System.EnvironmentVariableTarget]::User)
        $env:INKSCAPE_HOME = "${env:LOCALAPPDATA}\Programs\Inkscape"

        if ( -Not (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape")) {
            New-Item -ItemType "Directory" -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape"
        }

        $FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape\Inkscape.lnk"

        if ( -Not (Test-Path -Path "${FullLinkPath}")) {
            $Shell = New-Object -ComObject ("WScript.Shell")
            $ShortCut = $Shell.CreateShortcut("${FullLinkPath}")
            $ShortCut.TargetPath = "%INKSCAPE_HOME%\bin\inkscape.exe"
            $ShortCut.Arguments = ""
            $ShortCut.WorkingDirectory = "%USERPROFILE%";
            $ShortCut.WindowStyle = 1;
            $ShortCut.Hotkey = "";
            $ShortCut.IconLocation = "%INKSCAPE_HOME%\bin\inkscape.exe, 0";
            $ShortCut.Description = "Inkscape";
            $ShortCut.Save()
        }

        $FullLinkPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape\Inkview.lnk"

        if ( -Not (Test-Path -Path "${FullLinkPath}")) {
            $Shell = New-Object -ComObject ("WScript.Shell")
            $ShortCut = $Shell.CreateShortcut("${FullLinkPath}")
            $ShortCut.TargetPath = "%INKSCAPE_HOME%\bin\inkview.exe"
            $ShortCut.Arguments = ""
            $ShortCut.WorkingDirectory = "%USERPROFILE%";
            $ShortCut.WindowStyle = 1;
            $ShortCut.Hotkey = "";
            $ShortCut.IconLocation = "%INKSCAPE_HOME%\bin\inkview.exe, 0";
            $ShortCut.Description = "Inkview";
            $ShortCut.Save()
        }
    }
}