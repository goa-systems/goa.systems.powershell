if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$name = "paintnet"
	$version = "4.2.12"
	$setup = "paint.net.$version.install.zip"
	$dlurl = "https://www.dotpdn.com/files/$setup"


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

	if(Test-Path -Path "$env:TEMP\Paint.NET"){
	Remove-Item -Recurse -Path "$env:TEMP\Paint.NET"
	}
	New-Item -ItemType Directory -Path "$env:TEMP\Paint.NET"
	Expand-Archive -Path "C:\ProgramData\InstSys\paintnet\$setup" -DestinationPath "$env:TEMP\Paint.NET"

	Get-ChildItem "$env:TEMP\Paint.NET" -Filter "*.exe" | Foreach-Object {
	$setupfile = $_.FullName
	Start-Process -Wait -WorkingDirectory "$env:TEMP\Paint.NET" -FilePath "$setupfile" -ArgumentList "/createMsi","/auto"
	}

	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:USERPROFILE\Desktop\PaintDotNetMsi\PaintDotNet_x64.msi","DESKTOPSHORTCUT=0"

	Remove-Item -Recurse "$env:TEMP\Paint.NET"
	Remove-Item -Recurse "$env:USERPROFILE\Desktop\PaintDotNetMsi"

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}