if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Uninstall.ps1")
	Start-Process -FilePath "pwsh.exe" -ArgumentList @("-File", "${PSScriptRoot}\Install.ps1")
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}
