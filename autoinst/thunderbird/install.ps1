$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name="thunderbird"
	$version="68.4.2"
	$setup="Thunderbird Setup $version.exe"
	$dlurl="https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/$version/win64/en-US/Thunderbird%20Setup%20$version.exe"
	
	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	
	<# Download, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")) {
		Start-BitsTransfer `
		-Source "$dlurl"`
		-Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}
	
	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\$name\install.ini" -Value "[Install]`nInstallDirectoryPath=$env:ProgramFiles\Mozilla Thunderbird`nQuickLaunchShortcut=false`nTaskbarShortcut=false`nDesktopShortcut=false`nStartMenuShortcuts=true`nStartMenuDirectoryName=Mozilla Thunderbird`nMaintenanceService=false"
	Start-Process -FilePath "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -ArgumentList "/INI=$env:SystemDrive\ProgramData\InstSys\$name\install.ini" -Wait
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}