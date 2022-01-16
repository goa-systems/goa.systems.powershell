$processes = @("node")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

[System.Environment]::SetEnvironmentVariable("NODEJS_HOME", $null, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\NodeJS"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\NodeJS" -Recurse -Force
}