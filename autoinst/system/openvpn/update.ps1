if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\uninstall.ps1") -Wait
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\install.ps1") -Wait
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "${PSScriptRoot}\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}