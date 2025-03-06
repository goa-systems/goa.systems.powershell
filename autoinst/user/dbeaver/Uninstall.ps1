$Processes = @("dbeaver")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" | Stop-Process -Force
}

Start-Sleep -Seconds 1

if(-not ([string]::IsNullOrEmpty("${env:DBEAVER_HOME}"))){
	if(Test-Path -Path "${env:DBEAVER_HOME}") {
		Remove-Item -Path "${env:DBEAVER_HOME}" -Recurse -Force
		[System.Environment]::SetEnvironmentVariable("DBEAVER_HOME", "", [System.EnvironmentVariableTarget]::User)
	}
}

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\DBeaver.lnk") {
	Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\DBeaver.lnk" -Force
}
