param (
	# The certificate file.
	[String] $PhpVersion = "7.4.8"
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

	$phpbin = "php-$PhpVersion-Win32-vc15-x64.zip"

	if(-not (Test-Path -Path "$env:ProgramData\InstSys\php\$phpbin")){
		$ProgressPreference = 'SilentlyContinue'
		Write-Host -Object "Starting php download."
		Invoke-WebRequest -Uri "https://windows.php.net/downloads/releases/$phpbin" -OutFile "$env:ProgramData\InstSys\php/$phpbin"
		Write-Host -Object "Php download done."
	}

	Expand-Archive -Path "$env:ProgramData\InstSys\php\$phpbin" -DestinationPath "$env:ProgramData\InstSys\php\php"

	Move-Item -Path "$env:ProgramData\InstSys\php\php" -Destination "$env:ProgramFiles\Php\$PhpVersion"

	# Reconfigure Apache for new versions
	if(Test-Path -Path "$env:ProgramData\Apache\conf\httpd.conf") {
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if ($_ -match 'LoadModule php7_module "C:/Program Files/Php/*'){
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "LoadModule php7_module `"C:/Program Files/Php/$PhpVersion/php7apache2_4.dll`""
			} else {
				Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value $_
			}
		}
		Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
		Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-PhpVersion","`"$PhpVersion`"" -Wait -Verb RunAs
}
