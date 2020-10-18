$processes = @("node")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
$NewPath = ""
foreach($pathvar in $pathvars){
	if( -not ($pathvar -like "*Node.js*") -and -not [string]::IsNullOrEmpty($pathvar)){
		$NewPath += "${pathvar};"
	}
}
[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Node.js"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Node.js" -Recurse -Force
}