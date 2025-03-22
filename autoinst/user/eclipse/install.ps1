[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $EclipseUrl = "https://mirror.dkm.cz/eclipse/eclipse/downloads/drops4/R-4.35-202502280140/eclipse-platform-4.35-win32-x86_64.zip",

    [Parameter()]
    [string]
    $EclipseSemVer = "4.35",

    [Parameter()]
    [string]
    $EclipseDateVer = "2025-03",

    [Parameter()]
    [string]
    $JavaUrl = "https://cdn.azul.com/zulu/bin/zulu23.32.11-ca-fx-jdk23.0.2-win_x64.zip",

    [Parameter()]
    [string]
    $EclipseInstallDir = "${env:LOCALAPPDATA}\Programs\Eclipse",

    [Parameter()]
    [string]
    $JavaInstallDir = "${env:LOCALAPPDATA}\Programs\Java",

    [Parameter()]
    [string]
    $DefaultWorkspace = "${env:USERPROFILE}\workspaces\java"
)

$TempDir="${env:TEMP}\$(New-Guid)"

if (Test-Path "${TempDir}"){
    Remove-Item -Recurse -Force -Path "${TempDir}"
}
New-Item -ItemType "Directory" -Path "${TempDir}"

Start-BitsTransfer -Source "$JavaUrl" -Destination "${TempDir}\java.zip"
Expand-Archive -Path "${TempDir}\java.zip" -DestinationPath "${TempDir}\java_out"

$JavaHome = ""
$JavaPackage = ""
Get-ChildItem -Path "${TempDir}\java_out" | ForEach-Object {
    $JavaHome += "$($_.FullName)"
    $JavaPackage += "$($_.Name)"
}

Start-BitsTransfer -Source "$EclipseUrl" -Destination "${TempDir}\eclipse.zip"
Expand-Archive -Path "${TempDir}\eclipse.zip" -DestinationPath "${TempDir}\eclipse_out"

$EclipseHome = ""
Get-ChildItem -Path "${TempDir}\eclipse_out" | ForEach-Object {
    $EclipseHome += "$($_.FullName)"
}

# Increase the memory limit to prevent errors
$EclipseIni = "${EclipseHome}\eclipse.ini"
(Get-Content -Path "$EclipseIni") -replace "Xms40m","Xms1024m" -replace "Xmx512m","Xmx4096m" | Set-Content -Path "$EclipseIni"

Start-Process `
    -FilePath "${EclipseHome}\eclipse.exe" `
    -Wait `
    -ArgumentList `
    "-vm", "`"${JavaHome}\bin\javaw.exe`"", `
    "-application", "org.eclipse.equinox.p2.director", `
    "-repository", "https://download.eclipse.org/releases/${EclipseDateVer}/,https://download.eclipse.org/eclipse/updates/${EclipseSemVer},https://de-jcup.github.io/update-site-eclipse-bash-editor/update-site,https://eclipse-uc.sonarlint.org,https://download.springsource.com/release/TOOLS/sts4/update/e${EclipseSemVer}/", `
    "-installIU", "org.eclipse.jgit.feature.group,org.eclipse.jgit.gpg.bc.feature.group,org.eclipse.jgit.http.apache.feature.group,org.eclipse.jgit.lfs.feature.group,org.eclipse.jgit.ssh.apache.feature.group,org.eclipse.jgit.ssh.jsch.feature.group,org.eclipse.buildship.feature.group,org.eclipse.jdt.feature.group,org.eclipse.jst.enterprise_ui.feature.feature.group,org.eclipse.jst.web_ui.feature.feature.group,org.eclipse.jst.web_js_support.feature.feature.group,org.eclipse.jdt.source.feature.group,org.eclipse.wst.web_ui.feature.feature.group,org.eclipse.wst.web_js_support.feature.feature.group,org.eclipse.wst.xml_ui.feature.feature.group,org.eclipse.wst.xsl.feature.feature.group,org.eclipse.wst.jsdt.feature.feature.group,org.eclipse.wst.jsdt.chromium.debug.feature.feature.group,org.eclipse.wildwebdeveloper.feature.feature.group,org.eclipse.egit.feature.group,org.eclipse.egit.gitflow.feature.feature.group,org.eclipse.m2e.sdk.feature.feature.group,org.eclipse.m2e.feature.feature.group,org.eclipse.m2e.pde.feature.feature.group,org.eclipse.m2e.logback.feature.feature.group,org.eclipse.epp.mpc.feature.group,org.springframework.tooling.boot.ls.feature.feature.group,org.springframework.ide.eclipse.boot.dash.feature.feature.group,org.springframework.boot.ide.main.feature.feature.group,org.sonarlint.eclipse.feature.feature.group,de.jcup.basheditor.feature.group"


# Enabling automatic updates
$Folder = "${EclipseHome}\p2\org.eclipse.equinox.p2.engine\profileRegistry\SDKProfile.profile\.data\.settings"
$File = "org.eclipse.equinox.p2.ui.sdk.scheduler.prefs"

if ( -Not (Test-Path "${Folder}") ){
	New-Item -ItemType "Directory" -Path "${Folder}"
}

Set-Content -Path "${Folder}\${File}" -Value "eclipse.preferences.version=1
enabled=true
fuzzy_recurrence=Once a day"

Get-ChildItem -Path "${EclipseHome}\configuration\*.log" | ForEach-Object {
    if(((Get-Content -Path $_) -match "^.*Overall install request is satisfiable$") -contains "!MESSAGE Overall install request is satisfiable"){
        Remove-Item -Path $_
    }
}

if(Test-Path -Path "${EclipseInstallDir}"){
    Remove-Item -Recurse -Force -Path "${EclipseInstallDir}"
}

Move-Item -Path "${EclipseHome}" -Destination "${EclipseInstallDir}"

[System.Environment]::SetEnvironmentVariable("ECLIPSE_HOME", "${EclipseInstallDir}", [System.EnvironmentVariableTarget]::User)
$env:ECLIPSE_HOME="${EclipseInstallDir}"

if(-Not (Test-Path -Path "${JavaInstallDir}\${JavaPackage}")){
    Move-Item -Path "${JavaHome}" -Destination "${JavaInstallDir}\${JavaPackage}"
}

if(-Not (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse")){
    New-Item -ItemType "Directory" -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse"
}

if ( -Not (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse\Eclipse.lnk")) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse\Eclipse.lnk")
    $ShortCut.TargetPath = "%ECLIPSE_HOME%\eclipse.exe"
    $ShortCut.Arguments = "-vm `"${JavaInstallDir}\${JavaPackage}\bin\javaw.exe`" -data `"${DefaultWorkspace}`""
    $ShortCut.WorkingDirectory = "%USERPROFILE%";
    $ShortCut.WindowStyle = 1;
    $ShortCut.Hotkey = "";
    $ShortCut.IconLocation = "%ECLIPSE_HOME%\eclipse.exe, 0";
    $ShortCut.Description = "Eclipse IDE";
    $ShortCut.Save()
}

if ( -Not (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse\Cleanup.lnk")) {
    $Shell = New-Object -ComObject ("WScript.Shell")
    $ShortCut = $Shell.CreateShortcut("${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse\Cleanup.lnk")
    $ShortCut.TargetPath = "%ECLIPSE_HOME%\eclipse.exe"
    $ShortCut.Arguments = "-vm `"${JavaInstallDir}\${JavaPackage}\bin\javaw.exe`" -application `"org.eclipse.equinox.p2.garbagecollector.application`""
    $ShortCut.WorkingDirectory = "%USERPROFILE%";
    $ShortCut.WindowStyle = 1;
    $ShortCut.Hotkey = "";
    $ShortCut.IconLocation = "%ECLIPSE_HOME%\eclipse.exe, 0";
    $ShortCut.Description = "Eclipse cleanup";
    $ShortCut.Save()
}

Remove-Item -Recurse -Force -Path "${TempDir}"