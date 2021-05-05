param (
	# Current apache version
	[String] $ApacheVersion = "2.4.47"
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

	<# Verify, that VCRedist is installed. #>
	if (-Not (Test-Path -Path "HKLM:\SOFTWARE\Classes\Installer\Dependencies\VC,redist*")) {
		Start-BitsTransfer -Source "https://aka.ms/vs/16/release/vc_redist.x64.exe" -Destination "$env:ProgramData\InstSys\apache\vc_redist.x64.exe"
		Start-Process -FilePath "$env:ProgramData\InstSys\apache\vc_redist.x64.exe" -ArgumentList @("/install","/passive","/norestart") -Wait
	}

	$apachebin = "httpd-$ApacheVersion-win64-VS16.zip"

	if(-not (Test-Path -Path "$env:ProgramData\InstSys\apache\$apachebin")){
		Write-Host -Object "Downloading from https://www.apachelounge.com/download/VS16/binaries/$apachebin"
		Start-BitsTransfer -Source "https://www.apachelounge.com/download/VS16/binaries/$apachebin" -Destination "$env:ProgramData\InstSys\apache"
	}

	Expand-Archive -Path "$env:ProgramData\InstSys\apache\$apachebin" -DestinationPath "$env:ProgramData\InstSys\apache\apache"

	Get-ChildItem -Path "$env:ProgramData\InstSys\apache\apache" | ForEach-Object {
		if($_.Name -like 'Apache*'){
			Move-Item -Path "$($_.FullName)" -Destination "$env:ProgramFiles\Apache\$ApacheVersion"
		}
	}
	Remove-Item -Recurse -Path "$env:ProgramData\InstSys\apache\apache"

	New-NetFirewallRule -DisplayName "Allow Apache" -Profile Any -Program "$env:ProgramFiles\Apache\$ApacheVersion\bin\httpd.exe" -Action Allow

	Set-Location -Path "$PSScriptRoot"

	# Reconfigure Apache for new versions
	if(Test-Path -Path "$env:ProgramData\Apache\conf\httpd.conf") {
		.\setup.ps1 -ApacheVersion $ApacheVersion -SetupType "Update"
	} else {
		.\setup.ps1 -ApacheVersion $ApacheVersion -SetupType "Initial"
	}

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"" -Wait -Verb RunAs
}