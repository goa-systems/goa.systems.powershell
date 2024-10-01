param (
	[Parameter(Mandatory=$true)]
	[String]
	$Directory
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	if(Test-Path -Path "$Directory"){
		Write-Host -Object "Starting installation. This computer will restart as soon as all updates are installed."
		Get-ChildItem -Path "$Directory" | Select-Object -Property "Name" | Where-Object {$_.Name -like 'Windows*'} | ForEach-Object {
			Start-Process -Wait -FilePath "wusa.exe" -ArgumentList "`"$Directory\$($_.Name)`"","/quiet","/norestart"
		}
		Restart-Computer
	} else {
		Write-Host -Object "Directory not found."
	}
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-Directory","`"$Directory`"" -Verb RunAs
}