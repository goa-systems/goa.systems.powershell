if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	. $PSScriptRoot\..\insttools\UninstallTools.ps1
	Stop-Processes -ProcessNames @("vivaldi","update_notifier")
	
	foreach ($UninstCommand in (Get-UninstallCommands -ApplicationName "OpenVPN" -UninstallProperty "UninstallString")) {

		if ([string]::IsNullOrEmpty($UninstCommand)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			$SilentString = "`"$UninstCommand`" /S"
			Write-Host -Object "Uninststring found $SilentString"
			Invoke-Expression "&$SilentString"
		}
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}