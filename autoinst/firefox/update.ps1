if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	# Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","uninstall.ps1"
	Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","install.ps1"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}