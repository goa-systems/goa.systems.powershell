if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$Version = "1.14.0"
	$Revision = "28885"
	$Setup = "TortoiseSVN-$Version.$Revision-x64-svn-$Version.msi"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tsvn")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\tsvn" -ItemType "Directory"
	}

	<# Download tsvn scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tsvn\$Setup")){
		Write-Host -Object "Downloading TortoiseSVN"
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest `
		-Uri "https://dotsrc.dl.osdn.net/osdn/storage/g/t/to/tortoisesvn/$Version/Application/$Setup" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\tsvn\$Setup"
		Write-Host -Object "Download done"
	}
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\tsvn\$Setup","INSTALLDIR=`"C:\Program Files\TortoiseSVN`"","ADDLOCAL=ALL"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}