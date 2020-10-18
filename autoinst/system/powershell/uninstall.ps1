if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	function Get-Uuid {
		$var1 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "PowerShell 7" }
		$var2 = $var1.PSChildName
		return $var2
	}
	$uuid = Get-Uuid
	if ([string]::IsNullOrEmpty($uuid)) {
		Write-Host -Object "Powershell Core installation not found. Exiting."
	} else {
		Start-Process "msiexec" -ArgumentList "/uninstall", "$uuid", "/passive","/norestart"
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}