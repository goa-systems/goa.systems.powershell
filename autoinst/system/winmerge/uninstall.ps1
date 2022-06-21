if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$processes = @("WinMergeU")
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

	$AutoRestartShellEnabled = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" | Select-Object -ExpandProperty "AutoRestartShell")
	if($AutoRestartShellEnabled -eq 1){
		# Temporary disable automatic restarting of during uninstall.
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 0
	}
	Get-Process "explorer" -ErrorAction SilentlyContinue | Stop-Process -Force

	Start-Sleep -Seconds 3
	
	if(Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WinMerge.lnk") {
		Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WinMerge.lnk"
		Write-Host -Object "Local AppData Startmenu link found and removed."
	}
	
	if(Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\WinMerge.lnk") {
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\WinMerge.lnk"
		Write-Host -Object "Global ProgramData Startmenu link found and removed."
	}
	
	if(Test-Path -Path "$env:Public\Desktop\WinMergeU.lnk") {
		Remove-Item -Path "$env:Public\Desktop\WinMergeU.lnk"
		Write-Host -Object "Global Desktop link found and removed."
	}
	
	if(Test-Path -Path "$env:ProgramFiles\WinMerge") {
		Remove-Item -Path "$env:ProgramFiles\WinMerge" -Recurse
		Write-Host -Object "Program directory found and removed."
	}

	Start-Process -FilePath "explorer"
	if($AutoRestartShellEnabled -eq 1){
		# Restore the original setting.
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoRestartShell" -Value 1
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}