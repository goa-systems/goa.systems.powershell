param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Gradle"
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
$Json = Invoke-RestMethod -Uri "https://services.gradle.org/versions/current" -Headers

$FileName = "gradle-$($Json.version)-bin.zip"

$DownloadDir = "$env:ProgramData\InstSys\gradle"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$env:TEMP\GradleInst"){
	Remove-Item -Recurse -Force -Path "$env:TEMP\GradleInst"
}
New-Item -ItemType "Directory" -Path "$env:TEMP\GradleInst"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$($Json.downloadUrl)" -OutFile "$DownloadDir\$FileName"

if(Test-Path -Path "$DownloadDir\$FileName"){
	Expand-Archive -Path "$DownloadDir\$FileName" -DestinationPath "$env:TEMP\GradleInst"
	<# Move extracted folder to the program installation directory. #>
	Get-ChildItem -Path "$env:TEMP\GradleInst" | ForEach-Object {
		Move-Item -Path $_.FullName -Destination "$InstallDir"
		[System.Environment]::SetEnvironmentVariable('GRADLE_HOME',"$InstallDir\$($_.Name)",[System.EnvironmentVariableTarget]::User)
	}
}