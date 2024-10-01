if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$name = "paintnet"
	$version = $Json.version
	$setup = "paint.net.${version}.winmsi.x64.zip"
	$dlurl = "https://github.com/paintdotnet/release/releases/download/v${version}/$setup"


	If(Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name"){
		Remove-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -Recurse -Force
	}
	New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name\extract" -ItemType "Directory"

	<# Download if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")){
		Write-Host "Downloading from $dlurl"
		Start-BitsTransfer `
		-Source $dlurl `
		-Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}

	Expand-Archive -Path "C:\ProgramData\InstSys\$name\$setup" -DestinationPath "C:\ProgramData\InstSys\$name\extract"

	Get-ChildItem "C:\ProgramData\InstSys\$name\extract" -Filter "*.msi" | Foreach-Object {
		Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$($_.FullName)","DESKTOPSHORTCUT=0"
	}

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}