param (
	# The certificate file.
	[String] $PhpVersion = "8.0.8"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	if(Test-Path -Path "$env:ProgramFiles\Php\$PhpVersion"){
		Write-Error -Message "Php version $PhpVersion is already installed in $env:ProgramFiles\Apache\$PhpVersion. Please uninstall first."
		exit -2
	}

	if( -not (Test-Path -Path "$env:ProgramData\InstSys\php")){
		New-Item -ItemType "Directory" -Path "$env:ProgramData\InstSys\php"
	}

	if( -not (Test-Path -Path "$env:ProgramFiles\Php")){
		New-Item -ItemType "Directory" -Path "$env:ProgramFiles\Php"
	}

	$phpbin = "php-$PhpVersion-Win32-vs16-x64.zip"

	if(-not (Test-Path -Path "$env:ProgramData\InstSys\php\$phpbin")){
		$ProgressPreference = 'SilentlyContinue'
		Write-Host -Object "Starting php download."
		Invoke-WebRequest -Uri "https://windows.php.net/downloads/releases/$phpbin" -OutFile "$env:ProgramData\InstSys\php/$phpbin"
		Write-Host -Object "Php download done."
	}
	Expand-Archive -Path "$env:ProgramData\InstSys\php\$phpbin" -DestinationPath "$env:ProgramData\InstSys\php\php"
	Move-Item -Path "$env:ProgramData\InstSys\php\php" -Destination "$env:ProgramFiles\Php\$PhpVersion"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-PhpVersion","`"$PhpVersion`"" -Wait -Verb RunAs
}
