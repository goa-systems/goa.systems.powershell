if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name = "vivaldi"
	$version = "3.4.2066.99"
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
	# Disable update notificaiton. Updates are handled through this script.
	Get-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" | Select-Object -ExpandProperty "Property" | ForEach-Object {
		if( "Vivaldi Update Notifier" -eq $_){
			Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Vivaldi Update Notifier"
			Write-Host -Object "Update notification disabled."
		}
	}
	
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}