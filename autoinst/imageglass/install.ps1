if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$version = "7.6.4.30"
	$dlversion = $version.Replace(".","-") + "-44"
	$setup = "ImageGlass_${version}_x64.msi"
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\imageglass")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\imageglass" -ItemType "Directory"
	}
	<# Download imageglass scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\imageglass\$setup")){
		$ProgressPreference = 'SilentlyContinue'
		$uri = "https://imageglass.org/release/imageglass-$dlversion/download"
		Invoke-WebRequest `
		-Uri "$uri" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\imageglass\$setup"
	}
	Start-Process -Wait -FilePath "msiexec" -ArgumentList "/qb","/i","$env:SystemDrive\ProgramData\InstSys\imageglass\$setup"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}