
try { gradle | Out-Null } catch {}
if(-not ($?)){
	Write-Host -Object "Gradle not installed."
} else {
	Write-Host -Object "Gradle installed. Trying to stop all deamons."
	Start-Process -FilePath "gradle" -ArgumentList "--stop" -Wait
}

# Delete directories
$TargetPath = "$env:LOCALAPPDATA\Programs\Gradle"
if(Test-Path -Path "$TargetPath"){
	Remove-Item -Recurse -Force -Path "$TargetPath"
}

# Remove Gradle from path
$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
$NewPath = ""
foreach($pathvar in $pathvars){
	if( -not ($pathvar -like "*gradle*") -and -not [string]::IsNullOrEmpty($pathvar)){
		$NewPath += "${pathvar};"
	}
}
[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Gradle"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Gradle" -Recurse -Force
}

<# Testing for Gradle creates a directory ".gradle". This is not needed and is removed by the following code. #>
if(Test-Path -Path "$PSScriptRoot\.gradle"){
	Remove-Item -Path "$PSScriptRoot\.gradle" -Recurse -Force
}