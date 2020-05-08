param (
	# The apache version
	[Parameter (Mandatory=$false)]
	[String] $ApacheVersion = "2.4.41",

	# port to listen on
	[Parameter (Mandatory=$false)]
	[String] $ListeningPort = "80",

	# Make initial setup
	[Parameter (Mandatory=$true)]
	[String] $SetupType = "Initial"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	if($SetupType -eq "initial"){
		New-Item -ItemType "Directory" -Path "$env:ProgramData\Apache"
		New-Item -ItemType "Directory" -Path "$env:ProgramData\Apache\conf"
		New-Item -ItemType "Directory" -Path "$env:ProgramData\Apache\www"
		Copy-Item -Path "$env:ProgramFiles\Apache\$ApacheVersion\conf\httpd.conf" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if($_ -match 'Define SRVROOT *'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "Define SRVROOT `"C:/Program Files/Apache/$ApacheVersion`""
			} elseif($_ -match 'DocumentRoot "\${SRVROOT}/htdocs"'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "DocumentRoot `"$env:ProgramData\Apache\www`""
			} elseif($_ -match '<Directory "\${SRVROOT}/htdocs"'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "<Directory `"$env:ProgramData\Apache\www`">"
			} elseif($_ -match 'Listen 80'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "Listen $ListeningPort"
			} else {
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value $_
			}
		}
		Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
		Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
		Start-Process -FilePath "$env:ProgramFiles\Apache\$ApacheVersion\bin\httpd.exe" -ArgumentList "-k","install","-n","`"Apache web server`"","-f","`"$env:ProgramData\Apache\conf\httpd.conf`"" -Wait
		Start-Service -Name "Apache web server"
	} elseif ($SetupType -eq "Update") {
		# Just reconfigure the path to the apache installation.
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if($_ -match 'Define SRVROOT *'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "Define SRVROOT `"C:/Program Files/Apache/$ApacheVersion`""
			}
		}
		Stop-Service -Name "Apache web server"
		Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
		Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
		Start-Service -Name "Apache web server"
	} else {
		Write-Host -Object "SetupType unknown."
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"","-ListeningPort","`"$ListeningPort`"" -Wait -Verb RunAs
}