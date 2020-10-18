if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("TortoiseProc", "TSVNCache")
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
	
		$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "TortoiseSVN" }
		$var2 = $var1.QuietUninstallString
		return $var2
	}
	
	$regkeys = @(
		"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	)

	function Get-Uuid {
		$var1 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "TortoiseSVN" }
		$var2 = $var1.PSChildName
		return $var2
	}
	
	foreach ($regkey in $regkeys) {
		
		$uuid = Get-Uuid
		if ([string]::IsNullOrEmpty($uuid)) {
			Write-Host -Object "TortoiseSVN installation not found. Exiting."
		}
		else {
			Start-Process "msiexec" -ArgumentList "/uninstall", "$uuid", "/passive" -Wait
		}
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}