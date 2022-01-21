$processes = @("java", "javaw", "eclipse", "netbeans")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

# Delete directories
$TargetPath = "$env:LOCALAPPDATA\Programs\Java"

Get-ChildItem -Path "$TargetPath" | Where-Object {$_.Name -match "(.*)jdk8(.*)"} | ForEach-Object {
	Remove-Item -Recurse -Force -Path "$($_.FullName)"
}

if("$env:JAVA_HOME_8" -ne ""){
	[System.Environment]::SetEnvironmentVariable('JAVA_HOME_8', $null, [System.EnvironmentVariableTarget]::User)
}