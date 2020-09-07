if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$version = "3.0.1"
	$setup = "Nextcloud-$version-setup.exe"

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

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup" -ArgumentList "/S"
	Remove-Item -Path "$env:PUBLIC\Desktop\Nextcloud.lnk"
	Start-Process -FilePath "$env:ProgramFiles\Nextcloud\nextcloud.exe"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}