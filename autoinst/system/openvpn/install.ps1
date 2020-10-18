if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "openvpn"
	$version = "2.4.9"
	$setup = "openvpn-install-$version-I601-Win10.exe"
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
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -ArgumentList "/S", "/D=`"$env:ProgramFiles\OpenVPN`"", "/SELECT_SHORTCUTS=1", "/SELECT_OPENVPN=1", "/SELECT_SERVICE=1", "/SELECT_TAP=1", "/SELECT_OPENVPNGUI=1", "/SELECT_ASSOCIATIONS=1", "/SELECT_OPENSSL_UTILITIES=0", "/SELECT_EASYRSA=0", "/SELECT_PATH=1", "/SELECT_OPENSSLDLLS=1", "/SELECT_LZODLLS=1", "/SELECT_PKCS11DLLS=1"	
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}