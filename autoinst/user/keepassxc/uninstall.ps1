$Processes = @("KeePassXC")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" | Stop-Process -Force
}

Start-Sleep -Seconds 2

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\KeePassXC") {
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\KeePassXC" -Recurse -Force
}

if(Test-Path -Path "$env:USERPROFILE\Desktop\KeePass.lnk") {
	Remove-Item -Path "$env:USERPROFILE\Desktop\KeePass.lnk"
}

if(Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\KeePassXC.lnk") {
	Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\KeePassXC.lnk"
}
