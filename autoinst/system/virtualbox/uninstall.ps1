
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("VBoxSDS", "VBoxSVC", "VirtualBox")
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
		$var1 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -match "VirtualBox" }
		$var2 = $var1.PSChildName
		return $var2
	}
	$uuid = Get-Uuid
	if([string]::IsNullOrEmpty($uuid)){
		Write-Host -Object "VirtualBox installation not found. Exiting."
	} else {
		
		<# Remove extension packs #>
		Start-Process -FilePath " $env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" -ArgumentList "extpack","uninstall","`"Oracle VM VirtualBox Extension Pack`""
		
		<# Uninstall application #>
		Start-Process "msiexec" -ArgumentList "/uninstall","$uuid","/passive" -Wait
		
		<# Remove certificate from certificate store #>
		Get-ChildItem Cert:\LocalMachine\TrustedPublisher\ | Where-Object { $_.Subject -match 'CN=Oracle Corporation, OU=Virtualbox, O=Oracle Corporation, L=Redwood Shores, S=CA, C=US' } | Remove-Item
	}
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}