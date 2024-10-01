if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	. $PSScriptRoot\..\..\insttools\UninstallTools.ps1
	Stop-Processes -ProcessNames @("ShareX")
	
	foreach ($UninstCommand in (Get-UninstallCommands -ApplicationName "^ShareX$" -UninstallProperty "QuietUninstallString")) {

		if ([string]::IsNullOrEmpty($UninstCommand)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			Write-Host -Object "$UninstCommand"
			Invoke-Expression "&$UninstCommand"
		}
	}
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}