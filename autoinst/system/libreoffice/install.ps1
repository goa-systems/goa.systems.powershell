if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$Version = $Json.version
	$SetupFile = "LibreOffice_${Version}_Win_x86-64.msi"
	$DownloadUrl = "https://chuangtzu.ftp.acc.umu.se/mirror/documentfoundation.org/libreoffice/stable/${Version}/win/x86_64/${SetupFile}"
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