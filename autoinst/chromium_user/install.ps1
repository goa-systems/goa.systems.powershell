$Vers1 = "81.0.4044.138"
$Vers2 = "r737173"
$Vers3 = "1"
$FolderName = "ungoogled-chromium-${Vers1}-${Vers3}_windows"
$OutFile = "$FolderName.7z"
$OutPath = "$env:SystemDrive\ProgramData\InstSys\chromium\$OutFile"
$DestinationPath = "$env:LOCALAPPDATA\Programs\Chromium"
$Url = "https://github.com/macchrome/winchrome/releases/download/v${Vers1}-${Vers2}-Win64/${OutFile}"

If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\chromium")){
	New-Item -Path "$env:SystemDrive\ProgramData\InstSys\chromium" -ItemType "Directory"
}

if( -Not (Test-Path -Path "$OutPath")){
	$ProgressPreference = 'SilentlyContinue'
	Invoke-WebRequest -Uri "$Url" -OutFile "$OutPath"
}

try { 7z | Out-Null } catch {}
if(-not ($?)){
	Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
	Start-Sleep -s 10
} else {
	if(-Not (Test-Path -Path "$DestinationPath")){
		New-Item -ItemType "Directory" -Path "$DestinationPath"
	}
	Start-Process -FilePath "7z.exe" -ArgumentList "x","-aos","`"-o$DestinationPath`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$OutPath`"" -Wait -NoNewWindow
	if(-Not (Test-Path -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Chromium.lnk")){
		..\insttools\CreateShortcut.ps1 `
			-LinkName "Chromium" `
			-TargetPath "$DestinationPath\$FolderName\chrome.exe" `
			-Arguments "" `
			-IconFile "$DestinationPath\$FolderName\chrome.exe" `
			-IconId 0 `
			-Description "Chromium Browser" `
			-WorkingDirectory "%UserProfile%" `
			-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")
	}
}
