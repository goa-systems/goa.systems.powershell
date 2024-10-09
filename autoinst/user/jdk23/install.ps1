$InstallDir = "$env:LocalAppData\Programs\Java"
$Json = ConvertFrom-Json -InputObject (Get-Content -Raw -Path "$PSScriptRoot\version.json")
$FileName = "zulu$($Json.azulversion)-ca-fx-jdk$($Json.javaversion)-win_x64.zip"
$DownloadUrl = "https://cdn.azul.com/zulu/bin/$FileName"
$DownloadDir = "$($env:TEMP)\$(New-Guid)"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}

if(Test-Path -Path "$DownloadDir"){
	Remove-Item -Recurse -Force -Path "$DownloadDir"
}
New-Item -ItemType "Directory" -Path "$DownloadDir"

if(-not (Test-Path -Path "$DownloadDir\$FileName")){
	Write-Host -Object "Downloading file $FileName from $DownloadUrl into $DownloadDir"
	$ProgressPreference = 'SilentlyContinue'
	Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$DownloadDir\$FileName"
}

Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$DownloadDir"

Get-ChildItem -Path "$DownloadDir" -Directory | ForEach-Object {
	Move-Item -Path "$($_.FullName)" -Destination "$InstallDir" -Force
	[System.Environment]::SetEnvironmentVariable($Json.env, "$($InstallDir)\$($_.Name)", [System.EnvironmentVariableTarget]::User)
}

Remove-Item -Recurse -Force -Path "$DownloadDir"