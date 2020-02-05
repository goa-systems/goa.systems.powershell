param (
	# The apache version
	[String] $PhpVersion = "7.4.2"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	Get-Content "$env:ProgramData\Apache\conf\httpd.conf" | ForEach-Object {
		if($_ -match '#LoadModule xml2enc_module modules/mod_xml2enc.so'){
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "#LoadModule xml2enc_module modules/mod_xml2enc.so"
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "LoadModule php7_module `"C:/Program Files/Php/$PhpVersion/php7apache2_4.dll`""
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value ""
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "AddType application/x-httpd-php .php"
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "AddType application/x-httpd-phps .phps"
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "AddType application/x-httpd-php3 .php3 .phtml"
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "AddType application/x-httpd-php .html"
		} if($_ -match '^    DirectoryIndex index.html$'){
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value "    DirectoryIndex index.html index.php"
		} else {
			Add-Content -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Value $_
		}
	}
	Remove-Item -Path "$env:ProgramData\Apache\conf\httpd.conf"
	Move-Item -Path "$env:ProgramData\Apache\conf\httpd.conf.new" -Destination "$env:ProgramData\Apache\conf\httpd.conf"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-PhpVersion","`"$PhpVersion`"" -Wait -Verb RunAs
}