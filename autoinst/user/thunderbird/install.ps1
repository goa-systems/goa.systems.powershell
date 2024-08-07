Set-Location -Path "$PSScriptRoot"
$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json

$Version = $Json.version
$Setup="Thunderbird Setup $Version.exe"

$DownloadDir = "${env:TEMP}\$(New-Guid)"

$lang="en-US"
if($(Get-WinSystemLocale).Name.StartsWith("de")) {
	$lang="de"
}

If(Test-Path -Path "$DownloadDir"){
	Remove-Item -Recurse -Force "$DownloadDir"
}
New-Item -Path "$DownloadDir" -ItemType "Directory"
Start-BitsTransfer -Source "http://ftp.mozilla.org/pub/thunderbird/releases/$Version/win64/$lang/$Setup" -Destination "$DownloadDir\$Setup"

$INI=@"
[Install]
InstallDirectoryPath=$env:LOCALAPPDATA\Programs\Mozilla Thunderbird
QuickLaunchShortcut=false
DesktopShortcut=false
StartMenuShortcuts=true
MaintenanceService=false
"@

Set-Content -Path "$DownloadDir\install.ini" -Value $INI

$processes = @("thunderbird")
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

Start-Process -Wait -FilePath "$DownloadDir\$Setup" -ArgumentList @("/INI=`"$DownloadDir\install.ini`"")

Remove-Item -Recurse -Force "$DownloadDir"