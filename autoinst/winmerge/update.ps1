$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","uninstall.ps1"
	Start-Process -Wait -FilePath "powershell.exe" -ArgumentList "-File","install.ps1"
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}