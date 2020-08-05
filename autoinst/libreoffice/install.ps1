if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "libreoffice"
	$version = "7.0.0"
	$revision = "3"
	$setup = "LibreOffice_${version}.${revision}_Win_x64.msi"
	$dlurl = "https://ftp.gwdg.de/pub/tdf/libreoffice/stable/$version/win/x86_64/$setup"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}

	<# Download if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemsDrive\ProgramData\InstSys\$name\$setup")) {
		Write-Host "Downloading from $dlurl"
		Start-BitsTransfer `
			-Source $dlurl `
			-Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}

	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb", "/i", "$env:SystemDrive\ProgramData\InstSys\$name\$setup", "REGISTER_ALL_MSO_TYPES=1", "INSTALLLOCATION=`"C:\Program Files\LibreOffice`"", "ALLUSERS=1", "CREATEDESKTOPLINK=0", "ADDLOCAL=ALL", "UI_LANGS=en_US,de", "ADDLOCAL=ALL", "REMOVE=gm_o_Quickstart,gm_o_Activexcontrol"
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}