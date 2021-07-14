if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	
	$version = $Json.version
	$setup = "Nextcloud-$version-x64.msi"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud" -ItemType "Directory"
	}

	<# Download nextcloud, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup")){
		Write-Host -Object "Downloading NextCloud from https://download.nextcloud.com/desktop/releases/Windows/$setup"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri "https://download.nextcloud.com/desktop/releases/Windows/$setup" -OutFile "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup"
		Write-Host -Object "Download done"
	}

	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/i", "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup", "/passive", "/norestart")
	Remove-Item -Path "$env:PUBLIC\Desktop\Nextcloud.lnk"
	Start-Process -FilePath "$env:ProgramFiles\Nextcloud\nextcloud.exe"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}