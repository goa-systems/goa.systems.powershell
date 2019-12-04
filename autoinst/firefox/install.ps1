$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$ffvers = "71.0"
	$ffsetup="Firefox Setup $ffvers.exe"

	$lang="en-US"
	if($(Get-Culture).Name.StartsWith("de")) {
		$lang="de"
	}

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\firefox\$lang")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\firefox\$lang" -ItemType "Directory"
	}

	<# Download Gimp, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\firefox\$ffsetup")){
		Start-BitsTransfer `
		-Source "http://ftp.mozilla.org/pub/firefox/releases/$ffvers/win64/$lang/$ffsetup" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\firefox\$lang\$ffsetup"
	}

	$INI=@"
InstallDirectoryPath=$env:ProgramFiles\Mozilla Firefox
QuickLaunchShortcut=false
DesktopShortcut=false
StartMenuShortcuts=true
MaintenanceService=false
"@

	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\firefox\mff.ini" -Value $INI

	Start-Process -Wait `
		-FilePath "$env:SystemDrive\ProgramData\InstSys\firefox\$lang\$ffsetup" `
		-ArgumentList "/INI=`"$env:SystemDrive\ProgramData\InstSys\firefox\mff.ini`""
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}