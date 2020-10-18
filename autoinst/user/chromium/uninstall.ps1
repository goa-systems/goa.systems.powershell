$DestinationPath = "$env:LOCALAPPDATA\Programs\Chromium"

if(Test-Path -Path "$DestinationPath"){
	Remove-Item -Path "$DestinationPath" -Recurse -Force
}

if(Test-Path -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Chromium.lnk"){
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Chromium.lnk" -Force
}