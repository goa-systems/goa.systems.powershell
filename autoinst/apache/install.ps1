param (
	# The certificate file.
	[String] $ApacheVersion = "2.4.41"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	# Preliminary checks
	if(Test-Path -Path "$env:ProgramFiles\Apache\$ApacheVersion"){
		Write-Error -Message "Version $ApacheVersion is already installed in $env:ProgramFiles\Apache\$ApacheVersion. Please uninstall first."
		exit -1
	}

	If (Get-Service -Name "Apachewebserver" -ErrorAction SilentlyContinue) {
		Write-Error -Message "Service is already installed. Please uninstall first."
		exit -2
	}

	if( -not (Test-Path -Path "$env:ProgramData\InstSys\apache")){
		New-Item -ItemType "Directory" -Path "$env:ProgramData\InstSys\apache"
	}

	if( -not (Test-Path -Path "$env:ProgramFiles\Apache")){
		New-Item -ItemType "Directory" -Path "$env:ProgramFiles\Apache"
	}

	$apachebin = "httpd-$ApacheVersion-win64-VS16.zip"

	if(-not (Test-Path -Path "$env:ProgramData\InstSys\apache\$apachebin")){
		Start-BitsTransfer -Source "https://www.apachelounge.com/download/VS16/binaries/$apachebin" -Destination "$env:ProgramData\InstSys\apache"
	}

	Expand-Archive -Path "$env:ProgramData\InstSys\apache\$apachebin" -DestinationPath "$env:ProgramData\InstSys\apache\apache"

	Get-ChildItem -Path "$env:ProgramData\InstSys\apache\apache" | ForEach-Object {
		if($_.Name -like 'Apache*'){
			Move-Item -Path "$($_.FullName)" -Destination "$env:ProgramFiles\Apache\$ApacheVersion"
		}
	}
	Remove-Item -Recurse -Path "$env:ProgramData\InstSys\apache\apache"

	# Reconfigure Apache for new versions
	if(Test-Path -Path "$env:ProgramData\Apache\conf\httpd.conf") {
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if($_ -match 'Define SRVROOT *'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "Define SRVROOT `"C:/Program Files/Apache/$ApacheVersion`""
			} else {
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value $_
			}
		}
		Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
		Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"" -Wait -Verb RunAs
}