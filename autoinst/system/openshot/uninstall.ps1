if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	. $PSScriptRoot\..\..\insttools\UninstallTools.ps1
	Stop-Processes -ProcessNames @("openshot-qt")
	
	foreach ($UninstCommand in (Get-UninstallCommands -ApplicationName "openshot" -UninstallProperty "QuietUninstallString")) {

		if ([string]::IsNullOrEmpty($UninstCommand)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			$SilentString = "$UninstCommand --force-uninstall"
			Write-Host -Object "Uninststring found $SilentString"
			Invoke-Expression "&$SilentString"
		}
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}