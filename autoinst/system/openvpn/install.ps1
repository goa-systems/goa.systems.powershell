if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "openvpn"
	$version = "2.5.0"
	$setup = "OpenVPN-$version-I601-amd64.msi"
	$dlurl = "https://swupdate.openvpn.org/community/releases/$setup"
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	<# Download if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")){
		Write-Host "Downloading from $dlurl"
		Start-BitsTransfer `
		-Source $dlurl `
		-Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/passive", "/i", "$env:SystemDrive\ProgramData\InstSys\$name\$setup")
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}