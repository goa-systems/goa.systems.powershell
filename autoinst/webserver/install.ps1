# Version definitions
$apachevers = "2.4.41"
$phpvers = "7.4.2"

# Preliminary checks
if(Test-Path -Path "$env:ProgramFiles\Apache\$apachevers"){
	Write-Error -Message "Version $apachevers is already installed in $env:ProgramFiles\Apache\$apachevers. Please uninstall first."
	exit -1
}

if(Test-Path -Path "$env:ProgramFiles\Php\$phpvers"){
	Write-Error -Message "Php version $phpvers is already installed in $env:ProgramFiles\Apache\$phpvers. Please uninstall first."
	exit -2
}

If (Get-Service -Name "Apachewebserver" -ErrorAction SilentlyContinue) {
	Write-Error -Message "Service is already installed. Please uninstall first."
	exit -3
}

if( -not (Test-Path -Path "$env:ProgramData\InstSys\webserver")){
	New-Item -ItemType "Directory" -Path "$env:ProgramData\InstSys\webserver"
}

if( -not (Test-Path -Path "$env:ProgramFiles\Apache")){
	New-Item -ItemType "Directory" -Path "$env:ProgramFiles\Apache"
}

if( -not (Test-Path -Path "$env:ProgramFiles\Php")){
	New-Item -ItemType "Directory" -Path "$env:ProgramFiles\Php"
}

$apachebin = "httpd-$apachevers-win64-VS16.zip"
$phpbin = "php-$phpvers-Win32-vc15-x64.zip"

if(-not (Test-Path -Path "$env:ProgramData\InstSys\webserver\$apachebin")){
	Start-BitsTransfer -Source "https://www.apachelounge.com/download/VS16/binaries/$apachebin" -Destination "$env:ProgramData\InstSys\webserver"
}

if(-not (Test-Path -Path "$env:ProgramData\InstSys\webserver\$phpbin")){
	Start-BitsTransfer -Source "https://windows.php.net/downloads/releases/$phpbin" -Destination "$env:ProgramData\InstSys\webserver"
}

Expand-Archive -Path "$env:ProgramData\InstSys\webserver\$apachebin" -DestinationPath "$env:ProgramData\InstSys\webserver\apache"
Expand-Archive -Path "$env:ProgramData\InstSys\webserver\$phpbin" -DestinationPath "$env:ProgramData\InstSys\webserver\php"

Get-ChildItem -Path "$env:ProgramData\InstSys\webserver\apache" | ForEach-Object {
	if($_.Name -like 'Apache*'){
		Move-Item -Path "$($_.FullName)" -Destination "$env:ProgramFiles\Apache\$apachevers"
	}
}

Move-Item -Path "$env:ProgramData\InstSys\webserver\php" -Destination "$env:ProgramFiles\Php\$phpvers"

Remove-Item -Recurse -Path "$env:ProgramData\InstSys\webserver\apache"

# Reconfigure Apache for new versions
Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
	if($_ -match 'Define SRVROOT *'){
		Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "Define SRVROOT `"C:/Program Files/Apache/$apachevers`""
	} elseif ($_ -match 'LoadModule php7_module "C:/Program Files/Php/*'){
		Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "LoadModule php7_module `"C:/Program Files/Php/$phpvers/php7apache2_4.dll`""
	} else {
		Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value $_
	}
}
Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"

Start-Process -FilePath "$env:ProgramFiles\Apache\$apachevers\bin\httpd.exe" -ArgumentList "-k","install","-n","`"Apache web server`"","-f","`"$env:ProgramData\Apache\conf\httpd.conf`""
