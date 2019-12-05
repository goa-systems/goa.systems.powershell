$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$version = "2.6.1"
	$setup = "Nextcloud-$version-setup.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud" -ItemType "Directory"
	}

	<# Download nextcloud, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup")){
		Start-BitsTransfer `
		-Source "https://download.nextcloud.com/desktop/releases/Windows/$setup" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup"
	}

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\nextcloud\$setup" -ArgumentList "/S"
	Remove-Item -Path "$env:PUBLIC\Desktop\Nextcloud.lnk"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}