if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$version = "1.13.1"
	$setup = "TortoiseSVN-$version.28686-x64-svn-1.13.0.msi"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tsvn")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\tsvn" -ItemType "Directory"
	}

	<# Download tsvn scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\tsvn\$setup")){
		Invoke-WebRequest `
		-Uri "https://dotsrc.dl.osdn.net/osdn/storage/g/t/to/tortoisesvn/$version/Application/$setup" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\tsvn\$setup"
	}
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\tsvn\$setup","INSTALLDIR=`"C:\Program Files\TortoiseSVN`"","ADDLOCAL=ALL"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}