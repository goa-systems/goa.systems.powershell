if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("peazip")
	foreach($process in $processes){
		$p = Get-Process "$process" -ErrorAction SilentlyContinue
		if ($p) {
			"Process $p is running. Trying to stop it."
			$p | Stop-Process -Force
		} else {
			"Process $process is not running."
		}
	}
	
	function Get-UninstString {
	
		param(
			# Parent regkey in which to search for the uninstall string
			[parameter(Mandatory=$true)]
			[String]
			$regkey
		)
	
		$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "PeaZip" }
		$var2 = $var1.UninstallString
		return $var2
	}
	
	$regkeys = @(
		"HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	)
	
	foreach($regkey in $regkeys){
		$uninststring = Get-UninstString -regkey $regkey
		if([string]::IsNullOrEmpty($uninststring)){
			Write-Host -Object "Uninststring not found."
		} else {
			Write-Host -Object "Uninststring found $uninststring"
			$AutoRestartShellEnabled = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" | Select-Object -ExpandProperty "AutoRestartShell")
			if($AutoRestartShellEnabled -eq 1){
				# Temporary disable automatic restarting of during uninstall.
				Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 0
			}
			Get-Process "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force
			Start-Process -FilePath "$uninststring" -ArgumentList "/SILENT" -Wait
			Start-Process -FilePath "explorer"
			if($AutoRestartShellEnabled -eq 1){
				# Restore the original setting.
				Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 1
			}
		}
	}

	# Remove Gradle from path
	$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","Machine")) -split ";"
	$NewPath = ""
	foreach($pathvar in $pathvars){
		if( -not ($pathvar -like "*PeaZip*") -and -not [string]::IsNullOrEmpty($pathvar)){
			$NewPath += "${pathvar};"
		}
	}
	[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::Machine)
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}