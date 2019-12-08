[CmdletBinding()]
param (
	[String]
	$Directory = "$env:SystemDrive\Users",

	[String]
	$ExclusionList = "Public|All Users|desktop.ini"
)

Get-ChildItem -Path "$Directory" `
	| Where-Object { $_.Name -notmatch $ExclusionList } `
	| ForEach-Object { 
		Write-HOst -Object "$Directory\$_"
	}