. $PSScriptRoot\..\autoinst\insttools\UninstallTools.ps1

$UUIDs = Get-Uuid -SearchTerm "Microsoft .NET Core SDK"

foreach ($UUID in $UUIDs){
	Start-Process "msiexec" -ArgumentList @("/X", "$UUID" , "/qb")
}