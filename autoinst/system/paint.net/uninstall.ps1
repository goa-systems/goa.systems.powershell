if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$processes = @("PaintDotNet")
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
		$var1 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "paint.net" }
		$var2 = $var1.PSChildName
		return $var2
	}
	$uuid = Get-Uuid
	if([string]::IsNullOrEmpty($uuid)){
		Write-Host -Object "Paint.NET installation not found. Exiting."
	} else {
		Start-Process "msiexec" -ArgumentList "/uninstall","$uuid","/passive" -Wait
	}

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}