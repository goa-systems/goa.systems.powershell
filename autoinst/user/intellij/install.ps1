Get-Process | ForEach-Object {$_.ProcessName -match "^idea(\d*)"} | Stop-Process

$InstallDir = "$env:LocalAppData\Programs\IntelliJ"
$Json = (Get-Content -Path "version.json" | ConvertFrom-Json)
$FileName = "ideaIC-$($Json.version).win.zip"
$Url = "https://download-cdn.jetbrains.com/idea/$FileName"

$DownloadDir = "$env:Temp\$(New-Guid)"

if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Recurse -Force -Path "$DownloadDir"
}
New-Item -ItemType Directory -Path "$DownloadDir"

if(Test-Path -Path "$InstallDir"){
	Remove-Item -Recurse -Force -Path "$InstallDir"
}
New-Item -ItemType Directory -Path "$InstallDir"

# Download IntelliJ
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\$FileName"
Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$InstallDir"
..\..\insttools\CreateShortcut.ps1 `
	-LinkName "IntelliJ IDEA" `
	-TargetPath "$InstallDir\bin\idea64.exe" `
	-Arguments "" `
	-IconFile "$InstallDir\bin\idea64.exe" `
	-IconId 0 `
	-Description "IntelliJ IDEA" `
	-WorkingDirectory "%UserProfile%" `
	-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")
[System.Environment]::SetEnvironmentVariable("INTELLIJ_HOME", $NewPath, [System.EnvironmentVariableTarget]::User)
