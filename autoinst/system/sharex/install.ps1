if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$name = "sharex"
	$version = $Json.version
	$setup = "ShareX-$version-setup.exe"
	$dlurl = "https://github.com/ShareX/ShareX/releases/download/v$version/$setup"
	
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	<# Download if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")){
		Write-Host "Downloading from $dlurl"
		Invoke-WebRequest -Uri "$dlurl" -OutFile "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -ArgumentList "/SILENT","/NORUN"
	
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}