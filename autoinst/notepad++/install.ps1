if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$nppvers = "7.8.6"
	$nppsetup = "npp.$nppvers.Installer.x64.exe"
	$dlurl = "http://download.notepad-plus-plus.org/repository/7.x/$nppvers/$nppsetup"
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\npp")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\npp" -ItemType "Directory"
	}
	
	<# Download npp scm, if setup is not found in execution path. #>
	Write-Host -Object "Downloading from $dlurl"
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup")){
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest `
		-Uri $dlurl `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup"
	}
	
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\npp\$nppsetup" -ArgumentList "/S"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}