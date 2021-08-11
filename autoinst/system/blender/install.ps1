if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	
	$SetupFile = "blender-$($Json.major).$($Json.minor)-windows-x64.msi"
	$DownloadUrl = "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$($Json.major)/$SetupFile"
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