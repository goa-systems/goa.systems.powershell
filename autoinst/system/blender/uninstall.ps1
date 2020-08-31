if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("blender")
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

	function Get-Uuid {
		$var1 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "Blender" }
		$var2 = $var1.PSChildName
		return $var2
	}
	$uuid = Get-Uuid
	if ([string]::IsNullOrEmpty($uuid)) {
		Write-Host -Object "Mixxx installation not found. Exiting."
	} else {
		foreach ($uid in $uuid) {
			Start-Process "msiexec" -ArgumentList @("/uninstall","$uid","/passive","/norestart") -Wait
		}
	}
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}