if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$gimpssetup="gimp-2.10.18-setup-2.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\gimp")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\gimp" -ItemType "Directory"
	}
	
	<# Download Gimp, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\gimp\$gimpssetup")){
		Start-BitsTransfer `
		-Source  "https://download.gimp.org/pub/gimp/v2.10/windows/$gimpssetup"`
		-Destination "$env:SystemDrive\ProgramData\InstSys\gimp\$gimpssetup"
	}
	Start-Process -Wait `
	   -FilePath "$env:SystemDrive\ProgramData\InstSys\gimp\$gimpssetup" `
	   -ArgumentList "/SILENT","/NORESTART","/ALLUSERS","/DIR=`"$env:PROGRAMFILES\Gimp`""
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}