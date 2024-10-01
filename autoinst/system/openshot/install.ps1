if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$Version = $Json.version
	$setup = "OpenShot-$Version-x86_64.exe"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\openshot")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\openshot" -ItemType "Directory"
	}

	<# Download openshot, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\openshot\$setup")) {
		Write-Host -Object "Downloading OpenShot"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri "https://github.com/OpenShot/openshot-qt/releases/download/$Version/$setup" -OutFile "$env:SystemDrive\ProgramData\InstSys\openshot\$setup"
		Write-Host -Object "Download done"
	}

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\openshot\$setup" -ArgumentList "/SILENT","/NORESTART"
}
else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}
