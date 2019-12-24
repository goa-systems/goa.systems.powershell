$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "vivaldi"
	$version = "2.10.1745.23"
	$setup = "Vivaldi.$version.x64.exe"
	$dlurl = "https://downloads.vivaldi.com/stable/$setup"
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
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -ArgumentList "--vivaldi-silent","--do-not-launch-chrome","--system-level"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}