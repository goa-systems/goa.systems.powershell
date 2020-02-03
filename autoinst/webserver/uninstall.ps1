Stop-Service -Name "Apachewebserver" -Force
Start-Process "sc.exe" -ArgumentList "delete","Apachewebserver"
if(Test-Path -Path "$env:ProgramFiles\Apache"){
	Remove-Item -Path "$env:ProgramFiles\Apache" -Recurse -Force
}
if(Test-Path -Path "$env:ProgramFiles\Php"){
	Remove-Item -Path "$env:ProgramFiles\Php" -Recurse -Force
}