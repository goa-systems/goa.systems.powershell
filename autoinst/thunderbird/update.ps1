if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	<# Uninstall is not recommended in the update process because shortcuts (on taskbar for example) are deleted if application is removed first. #>
	# Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","uninstall.ps1"
	Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","install.ps1"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}