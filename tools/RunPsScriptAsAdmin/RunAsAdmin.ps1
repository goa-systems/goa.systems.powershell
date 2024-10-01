<#
.SYNOPSIS
	Run as admin script.
.DESCRIPTION
	This script runs itself as administrator (UAC request).
.EXAMPLE
  .\RunAsAdmin.ps1
#>
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	# Set-Location -Path "$PSScriptRoot"
	<#
	    This block get's executed if ran as admin. Keep the "Set-Location" line above to switch to the script directory. 
		If removed, the script is executed in "C:\Windows\System32".
		If you want to test that, comment the line and execute the script. The following script block schows the
		content of the variables.
	#>

	<#
		Script info block. Can be removed.
		It also shows how to access variables and execute Functions in text blocks.
	#>
	Write-Host -Object "======== Info block ========"
	Write-Host -Object "Script directory: ${PSScriptRoot}"
	Write-Host -Object "Script filename:  $($MyInvocation.MyCommand.Name)"
	Write-Host -Object "Get-Location:     $(Get-Location)"
	Write-Host -Object "====== End Info block ======"
	<# End of script info block.#>
	
	Read-Host -Prompt "Press a key to continue ..."
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$curscriptname" -Verb RunAs
}