if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	<# Do not call uninstall first. Otherwise there's no shell to execute install.ps1 with. #>
	Start-Process -FilePath "pwsh.exe" -ArgumentList ".\install.ps1"
	exit
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
	exit
}