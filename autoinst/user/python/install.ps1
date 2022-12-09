$Version = "3.11.0"
$OutFile = "python-$Version-amd64.exe"
$DownloadUrl = "https://www.python.org/ftp/python/$Version/$OutFile"

$DownloadDir = "$env:TEMP\$(New-Guid)"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

$ProgressPreference = 'SilentlyContinue'
if(-not (Test-Path -Path "$DownloadDir\$OutFile")){
	Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$DownloadDir\$OutFile"
}

Write-Host -Object "Installing python."
Start-Process -FilePath "$DownloadDir\$OutFile" -Wait -ArgumentList @(`
	"/passive",`
	"TargetDir=$env:USERPROFILE\AppData\Local\Programs\Python\$Version",`
	"Include_launcher=0",`
	"InstallLauncherAllUsers=0",`
	"Include_pip=1",`
	"Include_tcltk=1",`
	"PrependPath=1"
)

Write-Host -Object "Upgrading pip."
Start-Process -FilePath "$env:USERPROFILE\AppData\Local\Programs\Python\$Version\python.exe" -Wait -ArgumentList @(`
	"-m",`
	"pip",`
	"install",`
	"--upgrade",`
	"pip"`
)

Remove-Item -Recurse -Force -Path "$DownloadDir"