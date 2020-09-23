if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$MajorVersion = "2.90"
	$MinorVersion = "1"
	$SetupFile = "blender-$MajorVersion.$MinorVersion-windows64.msi"
	$DownloadUrl = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$MajorVersion/$SetupFile"
	$WorkingDir = "$env:ProgramData\InstSys\blender"
	if( -not (Test-Path -Path "$WorkingDir")){
		New-Item -ItemType "Directory" -Path "$WorkingDir"
	}
	if( -not (Test-Path -Path "$WorkingDir\$SetupFile")){
		$ProgressPreference = 'SilentlyContinue'
		Write-Host -Object "Downloading Blender"
		Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$WorkingDir\$SetupFile"
		Write-Host -Object "Download done"
	}
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/qb", "/i", "$WorkingDir\$SetupFile")
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}