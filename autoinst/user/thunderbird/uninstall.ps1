[CmdletBinding()]
param (
	# Optional uninstall string, if known externally.
	[Parameter()]
	[string]
	$UninstallString = ""
)

function Get-UninstString {
	
	param(
		# Parent regkey in which to search for the uninstall string
		[parameter(Mandatory = $true)]
		[String]
		$RegKey,

		# Name to search for
		[parameter(Mandatory = $true)]
		[String]
		$DisplayName
	)

	$Item = Get-ChildItem -Path $RegKey | Get-ItemProperty | Where-Object { $_.DisplayName -match "$DisplayName" }
	$UninstallString = $Item.UninstallString
	return $UninstallString
}

if([string]::IsNullOrEmpty($UninstallString)){
	$Process = Get-Process "thunderbird" -ErrorAction SilentlyContinue
	if ($Process) {
		"Process $Process is running. Trying to stop it."
		$Process | Stop-Process -Force
	}

	$UninstallString = Get-UninstString -RegKey "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall" -DisplayName "Mozilla Thunderbird"
}

if ( -Not [string]::IsNullOrEmpty($UninstallString)) {
	Start-Process -Wait -FilePath "$UninstallString" -ArgumentList "/S"
}

$IsAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$UninstallString = Get-UninstString -RegKey "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -DisplayName "Mozilla Thunderbird"

if ( (-Not [string]::IsNullOrEmpty($UninstallString)) -and $IsAdmin ){
	Start-Process -Wait -FilePath "$UninstallString" -ArgumentList "/S"
} elseif ((-Not [string]::IsNullOrEmpty($UninstallString)) -and (-Not $IsAdmin)) {
	Start-Process -FilePath "pwsh.exe" -Wait -Verb "RunAs" -ArgumentList @("-File", "$PSScriptRoot\$($MyInvocation.MyCommand.Name)", "-UninstallString", "${UninstallString}")
}

$UninstallString = Get-UninstString -RegKey "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -DisplayName "Mozilla Thunderbird"

if ( (-Not [string]::IsNullOrEmpty($UninstallString)) -and $IsAdmin ){
	Start-Process -Wait -FilePath "$UninstallString" -ArgumentList "/S"
} elseif ((-Not [string]::IsNullOrEmpty($UninstallString)) -and (-Not $IsAdmin)) {
	Start-Process -FilePath "pwsh.exe" -Wait -Verb "RunAs" -ArgumentList @("-File", "$PSScriptRoot\$($MyInvocation.MyCommand.Name)", "-UninstallString", "${UninstallString}")
}
