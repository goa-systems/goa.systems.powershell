$processes = @("java", "javaw", "eclipse", "netbeans")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}
$Json = ConvertFrom-Json -InputObject (Get-Content -Raw -Path "$PSScriptRoot\version.json")
# Delete directories
$TargetPath = "$env:LOCALAPPDATA\Programs\Java"

Get-ChildItem -Path "$TargetPath" | Where-Object {$_.Name -match "(.*)jdk20(.*)"} | ForEach-Object {
	Remove-Item -Recurse -Force -Path "$($_.FullName)"
}

if("$env:JAVA_HOME_18" -ne ""){
	[System.Environment]::SetEnvironmentVariable($Json.env, $null, [System.EnvironmentVariableTarget]::User)
}