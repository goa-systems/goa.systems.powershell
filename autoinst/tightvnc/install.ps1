$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$vers = "2.8.27"
	$setup = "tightvnc-$vers-gpl-setup-64bit.msi"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tightvnc")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\tightvnc" -ItemType "Directory"
	}

	<# Download tightvnc, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tightvnc\$setup")) {
		Start-BitsTransfer `
			-Source "https://www.tightvnc.com/download/$vers/$setup" `
			-Destination "$env:SystemDrive\ProgramData\InstSys\tightvnc\$setup"
	}

	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb", "/i", "$env:SystemDrive\ProgramData\InstSys\tightvnc\$setup", "/passive", "/norestart", "INSTALLDIR=`"C:\Program Files\TightVNC`"", "ADDLOCAL=Viewer"
}
else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}