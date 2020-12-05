Set-Location -Path "$PSScriptRoot"
$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json

$Version = $Json.version
$DownloadDir = "$env:ProgramData\InstSys\keepassxc"
$FileName = "KeePassXC-$Version-Win64-portable.zip"
$Url = "https://github.com/keepassxreboot/keepassxc/releases/download/$Version/$FileName"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

$ProgressPreference = 'SilentlyContinue'
if(-not (Test-Path -Path "$DownloadDir\$FileName")){
	Write-Host -Object "Downloading $FileName from $Url"
	Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\$FileName"
	Write-Host -Object "Download done"
}

if(Test-Path -Path "$DownloadDir\$FileName"){
	Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$env:TEMP\KeePassXC"
	Get-ChildItem -Path "$env:TEMP\KeePassXC" | ForEach-Object {
		$FolderName = $_.Name
		Move-Item -Path "$env:TEMP\KeePassXC\$FolderName" -Destination "$env:LOCALAPPDATA\Programs\KeePassXC"
	}
	Remove-Item -Path "$env:TEMP\KeePassXC"

	..\..\insttools\CreateShortcut.ps1 `
			-LinkName "KeePassXC" `
			-TargetPath "$env:LOCALAPPDATA\Programs\KeePassXC\KeePassXC.exe" `
			-Arguments "" `
			-IconFile "$env:LOCALAPPDATA\Programs\KeePassXC\KeePassXC.exe" `
			-IconId 0 `
			-Description "KeePassXC" `
			-WorkingDirectory "%UserProfile%" `
			-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")
	
	..\..\insttools\CreateShortcut.ps1 `
			-LinkName "KeePassXC saved password" `
			-TargetPath "`"pwsh.exe`""`
			-Arguments "-Command `"`""`
			-IconFile "$env:LOCALAPPDATA\Programs\KeePassXC\KeePassXC.exe" `
			-IconId 0 `
			-Description "KeePassXC with predefined passwor" `
			-WorkingDirectory "%UserProfile%" `
			-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")
}