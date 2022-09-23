$Url = "https://dl.pstmn.io/download/latest/win64"
$DownloadDir = "$env:TEMP\$(New-Guid)"
<# Generic download url brings setup with version number. #>
if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Path "$DownloadDir" -Recurse -Force
}
New-Item -ItemType "Directory" -Path "$DownloadDir"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\setup.exe"
Start-Process -FilePath "$DownloadDir\setup.exe" -ArgumentList "-s" -Wait

$ShortCut = "$env:USERPROFILE\Desktop\Postman.lnk"
if(Test-Path -Path "$ShortCut"){
	Remove-Item -Path "$ShortCut" -Force
}
Remove-Item -Recurse -Force -Path "$DownloadDir"