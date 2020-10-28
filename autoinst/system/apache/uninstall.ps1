param (
	# The certificate file.
	[String] $ApacheVersion = "2.4.46"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Stop-Service -DisplayName "Apache web server" -Force
    Start-Process -FilePath "$env:ProgramFiles\Apache\$ApacheVersion\bin\httpd.exe" -ArgumentList @("-k","uninstall","-n","`"Apache web server`"") -Wait
    Remove-Item -Path "$env:ProgramFiles\Apache\$ApacheVersion" -Recurse

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"" -Wait -Verb RunAs
}