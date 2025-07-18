Get-Process -Name "draw.io" | ForEach-Object {
	Stop-Process -Id $_.Id -Force
}

Start-Sleep -Seconds 1

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Draw.io.lnk") {
	Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Draw.io.lnk" -Force
}

$ProgramDir = "${env:LOCALAPPDATA}\Programs\Draw.io"
if(Test-Path -Path "${ProgramDir}") {
	Remove-Item -Recurse -Force -Path "${ProgramDir}"
}