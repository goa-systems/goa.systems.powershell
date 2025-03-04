$Processes = @("KeePassXC")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" | Stop-Process -Force
}

Start-Sleep -Seconds 1

if(-not ([string]::IsNullOrEmpty("${env:KEEPASSXC_HOME}"))){
	if(Test-Path -Path "${env:KEEPASSXC_HOME}") {
		Remove-Item -Path "${env:KEEPASSXC_HOME}" -Recurse -Force
		[System.Environment]::SetEnvironmentVariable("KEEPASSXC_HOME", "", [System.EnvironmentVariableTarget]::User)
	}
}

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\KeePassXC.lnk") {
	Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\KeePassXC.lnk" -Force
}
