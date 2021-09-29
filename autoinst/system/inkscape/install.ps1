if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$name = "inkscape"
	$setup = "$($Json.setup)"
	$dlurl = "$($Json.link)/$($Json.setup)"
	
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
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\$name\$setup","INSTALLLOCATION=`"$env:ProgramFiles\Inkscape`""
	Copy-Item -Path ".\default.svg" -Destination "$env:ProgramFiles\Inkscape\share\templates\default.svg"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Verb RunAs
}