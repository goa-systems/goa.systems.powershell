if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("rustdesk")
	foreach($process in $processes){
		$p = Get-Process "$process" -ErrorAction SilentlyContinue
		if ($p) {
			"Process $p is running. Trying to stop it."
			$p | Stop-Process -Force
		} else {
			"Process $process is not running."
		}
	}

	$Command = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Where-Object { $_.Name -match ".*RustDesk$" } | Get-ItemProperty).QuietUninstallString
	# Replace curly brackets with quoted curly brackets.
	$Command = $Command.Replace("{", "`"{").Replace("}", "}`"")
	Invoke-Expression "& ${Command}"
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}