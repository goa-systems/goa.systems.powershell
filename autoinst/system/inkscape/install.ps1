if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "inkscape"
	$version = "1.0.1"
	$setup = "inkscape-${version}-x64.msi"
	$dlurl = "https://media.inkscape.org/dl/resources/file/$setup"
	
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
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\$name\$setup","INSTALLLOCATION=`"$env:ProgramFiles\Inkscape`""
	Copy-Item -Path ".\default.svg" -Destination "$env:ProgramFiles\Inkscape\share\templates\default.svg"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Verb RunAs
}