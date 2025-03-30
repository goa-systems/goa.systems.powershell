if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$MinorVersion = $Json.minorversion
	$SetupFile = $Json.setupfile
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	if (Test-Path -Path "${DownloadDir}"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -ItemType "Directory" -Path "${DownloadDir}"
	$ProgressPreference = "SilentlyContinue"
	Write-Host -Object "Downloading ..."
	Invoke-WebRequest -Uri "https://download.gimp.org/gimp/${MinorVersion}/windows/${SetupFile}" -OutFile "${DownloadDir}\${SetupFile}"
	Write-Host -Object "Download finished."
	Start-Process -Wait -FilePath "${DownloadDir}\${SetupFile}" -ArgumentList @("/SILENT", "/MERGETASKS=`"!desktopicon`"", "/NORESTART", "/ALLUSERS", "/DIR=`"${env:PROGRAMFILES}\Gimp`"")
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}