$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$nppvers = "7.8.1"
	$nppsetup = "npp.$nppvers.Installer.x64.exe"
	$dlurl = "http://download.notepad-plus-plus.org/repository/7.x/$nppvers/$nppsetup"
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\npp")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\npp" -ItemType "Directory"
	}
	
	<# Download npp scm, if setup is not found in execution path. #>
	Write-Host -Object "Downloading from $dlurl"
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup")){
		Invoke-WebRequest `
		-Uri $dlurl `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup"
	}
	
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup" -ArgumentList "/S"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}