if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$Version = $Json.version
	
	$SetupFile = "putty-64bit-$Version-installer.msi"
	$DownloadUrl = "https://the.earth.li/~sgtatham/putty/$Version/w64/$SetupFile"
	
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\putty")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\putty" -ItemType "Directory"
	}
	
	<# Download putty, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\putty\$SetupFile")){
		Start-BitsTransfer `
		-Source "$DownloadUrl" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\putty\$SetupFile"
	}
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\putty\$SetupFile","/passive","INSTALLDIR=`"C:\Program Files\Putty`"","ADDLOCAL=FilesFeature,PathFeature,PPKFeature"	
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}