$processes = @("java", "eclipse", "netbeans")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

# Delete directories
$TargetPath = "$env:LOCALAPPDATA\Programs\Java"
if(Test-Path -Path "$TargetPath"){
	Remove-Item -Recurse -Force -Path "$TargetPath"
}

# Remove Java from path
$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
$NewPath = ""
foreach($pathvar in $pathvars){
	if( -not ($pathvar -like "*Java*") -and -not [string]::IsNullOrEmpty($pathvar)){
		$NewPath += "${pathvar};"
	}
}
[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Java"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Java" -Recurse -Force
}