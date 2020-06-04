. $PSScriptRoot\..\insttools\UninstallTools.ps1
Stop-Processes -ProcessNames @("Postman")

$UninstCommand = Get-UninstallCommandsUser -ApplicationName "postman" -UninstallProperty "QuietUninstallString"

if ([string]::IsNullOrEmpty($UninstCommand)) {
	Write-Host -Object "Uninststring not found."
} else {
	Write-Host -Object "$UninstCommand"
	Invoke-Expression "& $UninstCommand"
}