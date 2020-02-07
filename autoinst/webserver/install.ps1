param (
	# Apache version
	[String] $ApacheVersion = "2.4.41",

	# PHP version
	[String] $PhpVersion = "7.4.2"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	..\apache\install.ps1 -ApacheVersion = $ApacheVersion
	..\apache\setup.ps1 -ApacheVersion = $ApacheVersion -SetupType "Initial"
	..\php\install.ps1 -PhpVersion = $PhpVersion
	..\php\setup.ps1 -PhpVersion = $PhpVersion

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"","-PhpVersion","`"$PhpVersion`"" -Wait -Verb RunAs
}