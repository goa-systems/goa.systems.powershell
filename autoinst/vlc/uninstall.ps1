if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$p = Get-Process "vlc" -ErrorAction SilentlyContinue
	if ($p) {
		"Process vlc is running. Trying to stop it."
		$p | Stop-Process -Force
	}
	else {
		"Process vlc is not running."
	}
	
	function Get-UninstString {
		param(
			# Parent regkey in which to search for the uninstall string
			[parameter(Mandatory = $true)]
			[String]
			$regkey
		)
		$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "VLC media player" }
		$var2 = $var1.UninstallString
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
			Start-Process -FilePath "$uninststring" -ArgumentList "/S"
		}
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}