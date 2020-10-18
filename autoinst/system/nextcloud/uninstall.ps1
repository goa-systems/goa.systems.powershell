if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	. $PSScriptRoot\..\..\insttools\UninstallTools.ps1
	Stop-Processes -ProcessNames @("nextcloud")
	
	foreach ($UninstCommand in (Get-UninstallCommands -ApplicationName "nextcloud" -UninstallProperty "UninstallString")) {

		if ([string]::IsNullOrEmpty($UninstCommand)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			Write-Host -Object "Uninststring found $UninstCommand"
			Start-Process -FilePath "$UninstCommand" -ArgumentList "/S" -Wait
		}
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}