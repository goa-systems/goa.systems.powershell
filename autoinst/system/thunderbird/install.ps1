if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
		
	$name="thunderbird"
	$version=$Json.version
	$setup="Thunderbird Setup $version.exe"
	$dlurl="https://download.mozilla.org/?product=thunderbird-latest&os=win64&lang=en-US"
	
	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	
	<# Download, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")) {
		Start-BitsTransfer `
		-Source "$dlurl"`
		-Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}

	<# Stop Thunderbird if running. #>
	$processes = @("thunderbird")
	foreach($process in $processes){
		$p = Get-Process "$process" -ErrorAction SilentlyContinue
		if ($p) {
			"Process $p is running. Trying to stop it."
			$p | Stop-Process -Force
		} else {
			"Process $process is not running."
		}
	}
	
	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\$name\install.ini" -Value "[Install]`nInstallDirectoryPath=$env:ProgramFiles\Mozilla Thunderbird`nQuickLaunchShortcut=false`nTaskbarShortcut=false`nDesktopShortcut=false`nStartMenuShortcuts=true`nStartMenuDirectoryName=Mozilla Thunderbird`nMaintenanceService=false"
	Start-Process -FilePath "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -ArgumentList "/INI=$env:SystemDrive\ProgramData\InstSys\$name\install.ini" -Wait
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}