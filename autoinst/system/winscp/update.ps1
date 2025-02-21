if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "${PSScriptRoot}"
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Uninstall.ps1") -NoNewWindow
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Install.ps1") -NoNewWindow
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}