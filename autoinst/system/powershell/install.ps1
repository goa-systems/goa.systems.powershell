if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "powershell"
	$version = "7.1.3"
	$setup = "PowerShell-$version-win-x64.msi"
	$dlurl = "https://github.com/PowerShell/PowerShell/releases/download/v$version/$setup"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}

	<# Download if setup is not found in execution path. #>
	$ProgressPreference = 'SilentlyContinue'
		
	if ( -Not (Test-Path -Path "$env:SystemsDrive\ProgramData\InstSys\$name\$setup")) {
		Write-Host "Downloading from $dlurl"
		Invoke-WebRequest -Uri "$dlurl" -OutFile "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}

	Start-Process -FilePath "msiexec" -ArgumentList @("/package","$env:SystemDrive\ProgramData\InstSys\$name\$setup","/passive","ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1","ENABLE_PSREMOTING=1","REGISTER_MANIFEST=1")
	exit
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}