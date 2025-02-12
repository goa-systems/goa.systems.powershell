$Processes = @("KeePassXC")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" | Stop-Process -Force
}

Start-Sleep -Seconds 2

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\KeePassXC") {
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\KeePassXC" -Recurse -Force
}

[System.Environment]::SetEnvironmentVariable("KEEPASSXC_HOME", "", [System.EnvironmentVariableTarget]::User)