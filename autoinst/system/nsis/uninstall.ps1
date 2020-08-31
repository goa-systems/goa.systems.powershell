
# Remove Nsis from path
$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
$NewPath = ""
foreach($pathvar in $pathvars){
	if( -not ($pathvar -like "*nsis*") -and -not [string]::IsNullOrEmpty($pathvar)){
		$NewPath += "${pathvar};"
	}
}
[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Nsis"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Nsis" -Recurse -Force
}