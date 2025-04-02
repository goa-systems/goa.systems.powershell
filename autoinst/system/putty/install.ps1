if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$Version = $Json.version
	
	$SetupFile = "putty-64bit-$Version-installer.msi"
	$DownloadUrl = "https://the.earth.li/~sgtatham/putty/$Version/w64/$SetupFile"
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	
	If(Test-Path -Path "${DownloadDir}"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -Path "${DownloadDir}" -ItemType "Directory"
	
	<# Download putty, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "${DownloadDir}\$SetupFile")){
		Start-BitsTransfer `
		-Source "$DownloadUrl" `
		-Destination "${DownloadDir}\$SetupFile"
	}
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","${DownloadDir}\${SetupFile}","/passive","INSTALLDIR=`"C:\Program Files\Putty`"","ADDLOCAL=FilesFeature,PathFeature,PPKFeature"	
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}