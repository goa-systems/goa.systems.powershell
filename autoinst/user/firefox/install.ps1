$LatestVersion = (Invoke-RestMethod -Uri "https://product-details.mozilla.org/1.0/firefox_versions.json").LATEST_FIREFOX_VERSION

$Setup="Firefox Setup ${LatestVersion}.exe"

$DownloadDir = "${env:TEMP}\$(New-Guid)"

$Language="en-US"
if($(Get-WinSystemLocale).Name.StartsWith("de")) {
	$Language="de"
}

If(Test-Path -Path "${DownloadDir}"){
	Remove-Item -Recurse -Force "${DownloadDir}"
}
New-Item -Path "${DownloadDir}" -ItemType "Directory"

Start-BitsTransfer -Source "http://ftp.mozilla.org/pub/firefox/releases/${LatestVersion}/win64/${Language}/${Setup}" -Destination "${DownloadDir}\${Setup}"

$IniContent=@"
[Install]
InstallDirectoryPath=${env:LOCALAPPDATA}\Programs\Mozilla Firefox
QuickLaunchShortcut=false
DesktopShortcut=false
StartMenuShortcuts=true
MaintenanceService=false
"@

Set-Content -Path "${DownloadDir}\install.ini" -Value "${IniContent}"

$processes = @("firefox")
foreach ($process in $processes) {
	$p = Get-Process "$process" -ErrorAction SilentlyContinue
	if ($p) {
		"Process $p is running. Trying to stop it."
		$p | Stop-Process -Force
	}
	else {
		"Process $process is not running."
	}
}

Start-Process -Wait -FilePath "${DownloadDir}\${Setup}" -ArgumentList @("/INI=`"${DownloadDir}\install.ini`"")

Remove-Item -Recurse -Force "${DownloadDir}"