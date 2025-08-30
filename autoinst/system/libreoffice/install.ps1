if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	
	$BaseUrl = "https://download.documentfoundation.org/libreoffice/stable/"
	$Response = Invoke-WebRequest -Uri $BaseUrl
	$Versions = $Response.Links | Where-Object { $_.href -match '^\d' } | ForEach-Object { $_.href.TrimEnd('/') }
	$Version = $Versions | Sort-Object {[version]$_} | Select-Object -Last 1
	$SetupFile = "LibreOffice_${Version}_Win_x86-64.msi"
	$DownloadUrl = "${BaseUrl}${Latest}/win/x86_64/${SetupFile}"
	$DownloadDir = "$env:TEMP\$(New-Guid)"

	If (Test-Path -Path "${DownloadDir}") {
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -Path "${DownloadDir}" -ItemType "Directory"

	$ProgressPreference = "SilentlyContinue"
	Write-Host -Object "Downloading ..."
	Invoke-WebRequest -Uri "${DownloadUrl}" -OutFile "${DownloadDir}\${SetupFile}"
	Write-Host -Object "Download finished."
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb", "/i", "${DownloadDir}\${SetupFile}", "REGISTER_ALL_MSO_TYPES=1", "INSTALLLOCATION=`"C:\Program Files\LibreOffice`"", "ALLUSERS=1", "CREATEDESKTOPLINK=0", "ADDLOCAL=ALL", "UI_LANGS=en_US,de", "ADDLOCAL=ALL", "REMOVE=gm_o_Quickstart,gm_o_Activexcontrol"
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}