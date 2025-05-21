Get-Process | Where-Object { $_.Name -eq "inkscape" } | ForEach-Object { Stop-Process -Id $_.Id }
Get-Process | Where-Object { $_.Name -eq "inkview" } | ForEach-Object { Stop-Process -Id $_.Id }

Start-Sleep -Seconds 1

if(-not ([string]::IsNullOrEmpty("${env:INKSCAPE_HOME}"))){
	if(Test-Path -Path "${env:INKSCAPE_HOME}") {
		Remove-Item -Path "${env:INKSCAPE_HOME}" -Recurse -Force
		[System.Environment]::SetEnvironmentVariable("INKSCAPE_HOME", "", [System.EnvironmentVariableTarget]::User)
		Remove-ItemProperty -Path "HKCU:\Environment" -Name "INKSCAPE_HOME"
	}
}

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape") {
	Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Inkscape" -Recurse -Force
}
