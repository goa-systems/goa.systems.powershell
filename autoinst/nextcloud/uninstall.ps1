$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("nextcloud")
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

		$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "Nextcloud" }
		$var2 = $var1.QuietUninstallString
		return $var2
	}

	$regkeys = @(
		"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	)

	foreach ($regkey in $regkeys) {
		$uninststring = Get-UninstString -regkey $regkey

		if ([string]::IsNullOrEmpty($uninststring)) {
			Write-Host -Object "Uninststring not found."
		}
		else {
			Write-Host -Object "Uninststring found $uninststring"
			Start-Process -FilePath "$uninststring" -ArgumentList "/S" -Wait
		}
	}
}
else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}