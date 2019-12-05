$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("vivaldi", "update_notifier")
	foreach ($process in $processes) {
		$p = Get-Process "$process" -ErrorAction SilentlyContinue
		if ($p) {
			"Process $p is running. Trying to stop it."
			$p | Stop-Process -Force
		}
		else {
			"Process $process is not running."
		}
	}
	function Get-UninstString {
		param(
			# Parent regkey in which to search for the uninstall string
			[parameter(Mandatory = $true)]
			[String]
			$regkey
		)
		$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "Vivaldi" }
		$var2 = $var1.UninstallString
		return $var2
	}
	$regkeys = @(
		"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	)
	foreach ($regkey in $regkeys) {
		$uninststring = Get-UninstString -regkey $regkey
		$silentstring = "$uninststring --force-uninstall"
		if ([string]::IsNullOrEmpty($uninststring)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			Write-Host -Object "Uninststring found $silentstring"
			Invoke-Expression "&$silentstring"
		}
	}
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}