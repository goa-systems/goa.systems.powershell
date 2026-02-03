function Get-Installer {
    $ProgressPreference = "SilentlyContinue"
    $DownloadLink = ""
    (Invoke-WebRequest -Uri "https://www.python.org/downloads/").Links | ForEach-Object {
        if ($_.href -match "https:\/\/www.python.org\/ftp\/python/\d*\.\d*\.\d*\/Python-\d*\.\d*\.\d*\-amd64\.exe") {
            $DownloadLink += $_.href
        }
    }
    return $DownloadLink
}

$DownloadUrl = Get-Installer

$DownloadDir = "${env:TEMP}\$(New-Guid)"

if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Force -Recurse -Path "$DownloadDir"
}
New-Item -ItemType "Directory" -Path "$DownloadDir"

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "${DownloadUrl}" -OutFile "${DownloadDir}\python-installer.exe"


Write-Host -Object "Installing python."
Start-Process -FilePath "${DownloadDir}\python-installer.exe" -Wait -ArgumentList @(`
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