if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", ".\uninstall.ps1") -Wait
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", ".\install.ps1") -Wait
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}