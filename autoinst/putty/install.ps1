$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$vers = "0.73"
	$setup = "putty-64bit-$vers-installer.msi"
	
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\putty")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\putty" -ItemType "Directory"
	}
	
	<# Download putty, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\putty\$setup")){
		Start-BitsTransfer `
		-Source "https://the.earth.li/~sgtatham/putty/$vers/w64/$setup" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\putty\$setup"
	}
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\putty\$setup","/passive","INSTALLDIR=`"C:\Program Files\Putty`"","ADDLOCAL=FilesFeature,PathFeature,PPKFeature"	
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}