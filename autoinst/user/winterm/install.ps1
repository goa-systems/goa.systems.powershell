$CurrentVersion = "1.3.2651.0"
$FileName = "Microsoft.WindowsTerminal_${CurrentVersion}_8wekyb3d8bbwe.msixbundle"
$DownloadUrl = "https://github.com/microsoft/terminal/releases/download/v${CurrentVersion}/$FileName"
$ConfigFile = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

$DownloadDir = "$env:ProgramData\InstSys\wt"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

$ProgressPreference = 'SilentlyContinue'
if(-not (Test-Path -Path "$DownloadDir\$FileName")){
    Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$DownloadDir\$FileName"
}

Add-AppxPackage -Path "$DownloadDir\$FileName"

if(Test-Path -Path "$env:TEMP\settings.wt.backup.json"){
    Write-Host -Object "Restoring configuration from backup."
    Copy-Item -Path "$env:TEMP\settings.wt.backup.json" -Destination $ConfigFile
}