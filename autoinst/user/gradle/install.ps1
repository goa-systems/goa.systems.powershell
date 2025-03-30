$InstallDir = "$env:LOCALAPPDATA\Programs\Gradle"
$Json = (Invoke-RestMethod -Uri "https://services.gradle.org/versions/current")
$Version = $Json.version
$FileName = "gradle-${Version}-bin.zip"

$DownloadDir = "$env:TEMP\$(New-Guid)"

if(Test-Path -Path "${DownloadDir}"){
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

if(-not (Test-Path -Path "${InstallDir}")){
	New-Item -ItemType "Directory" -Path "${InstallDir}"
}

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$($Json.downloadUrl)" -OutFile "${DownloadDir}\${FileName}"

if(Test-Path -Path "${DownloadDir}\${FileName}"){
	Expand-Archive -Path "${DownloadDir}\${FileName}" -DestinationPath "${DownloadDir}"
	Move-Item -Path "${DownloadDir}\gradle-${Version}" -Destination "${InstallDir}"
	[System.Environment]::SetEnvironmentVariable("GRADLE_HOME", "${InstallDir}\gradle-${Version}", [System.EnvironmentVariableTarget]::User)
	$env:GRADLE_HOME = "${InstallDir}\gradle-${Version}"
}

Remove-Item -Recurse -Force -Path "${DownloadDir}"