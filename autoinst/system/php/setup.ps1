param (
	# The apache version
	[String] $PhpVersion = "7.4.12",

	# Make initial setup
	[String] $SetupType = "Initial"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$HttpConf    = "$env:ProgramData\Apache\conf\httpd.conf"
	$HttpConfNew = "$env:ProgramData\Apache\conf\httpd.conf.new"

	if($SetupType -eq "Initial"){
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if($_ -match '#LoadModule xml2enc_module modules/mod_xml2enc.so'){
				Add-Content -Path "$HttpConfNew" -Value "#LoadModule xml2enc_module modules/mod_xml2enc.so"
				Add-Content -Path "$HttpConfNew" -Value "LoadModule php7_module `"C:/Program Files/Php/$PhpVersion/php7apache2_4.dll`""
				Add-Content -Path "$HttpConfNew" -Value ""
				Add-Content -Path "$HttpConfNew" -Value "AddType application/x-httpd-php .php"
				Add-Content -Path "$HttpConfNew" -Value "AddType application/x-httpd-phps .phps"
				Add-Content -Path "$HttpConfNew" -Value "AddType application/x-httpd-php3 .php3 .phtml"
				Add-Content -Path "$HttpConfNew" -Value "AddType application/x-httpd-php .html"
			} if($_ -match '^    DirectoryIndex index.html$'){
				Add-Content -Path "$HttpConfNew" -Value "    DirectoryIndex index.html index.php"
			} else {
				Add-Content -Path "$HttpConfNew" -Value $_
			}
		}
	} elseif ($SetupType -eq "Update") {
		Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
			if($_ -match 'LoadModule php7_module*'){
				Add-Content -Path "$HttpConfNew" -Value "LoadModule php7_module `"C:/Program Files/Php/$PhpVersion/php7apache2_4.dll`""
			}
		}
	} else {
		Write-Host -Object "SetupType unknown."
	}
	Stop-Service -Name "Apache web server"
	Remove-Item -Path "$HttpConf"
	Move-Item -Path "$HttpConfNew" -Destination "$HttpConf"
	Start-Service -Name "Apache web server"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-PhpVersion","`"$PhpVersion`"","-SetupType","`"$SetupType`"" -Wait -Verb RunAs
}