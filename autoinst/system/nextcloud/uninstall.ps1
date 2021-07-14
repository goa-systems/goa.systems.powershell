if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	. $PSScriptRoot\..\..\insttools\UninstallTools.ps1
	Stop-Processes -ProcessNames @("nextcloud")
	
	<# Remove legacy setup based, 32bit and 64bit nextcloud installations. #>
	foreach ($UninstCommand in (Get-UninstallCommands -ApplicationName "nextcloud" -UninstallProperty "UninstallString")) {

		if ([string]::IsNullOrEmpty($UninstCommand) -or $UninstCommand.StartsWith("MsiExec")) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			Write-Host -Object "Uninststring found $UninstCommand"
			Start-Process -FilePath "$UninstCommand" -ArgumentList "/S" -Wait
		}
	}

	<# Remove msi based, 32bit and 64bit nextcloud installations. #>
	foreach ($Guid in (Get-Uuid -SearchTerm "nextcloud")) {

		$AutoRestartShellEnabled = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" | Select-Object -ExpandProperty "AutoRestartShell")
		if($AutoRestartShellEnabled -eq 1){
			# Temporary disable automatic restarting of during uninstall.
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 0
		}
		Get-Process "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force
		Start-Process -FilePath "msiexec" -ArgumentList @("/X", "$Guid", "/passive", "/norestart") -Wait
		Start-Process -FilePath "explorer"

		if($AutoRestartShellEnabled -eq 1){
			# Restore the original setting.
			Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 1
		}
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}