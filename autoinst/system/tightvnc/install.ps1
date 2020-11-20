if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	
	$vers = $Json.version
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
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}