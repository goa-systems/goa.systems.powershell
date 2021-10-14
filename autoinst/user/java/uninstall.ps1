$processes = @("java", "javaw", "eclipse", "netbeans")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

# Delete directories
$TargetPath = "$env:LOCALAPPDATA\Programs\Java"
if(Test-Path -Path "$TargetPath"){
	Remove-Item -Recurse -Force -Path "$TargetPath"
}

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Java"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Java" -Recurse -Force
}