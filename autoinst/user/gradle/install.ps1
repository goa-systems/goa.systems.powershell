param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Gradle"
)

$Headers = @{
    'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0'
	# 'Accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8'
	# 'Accept-Encoding' = 'gzip, deflate, br'
	# 'Accept-Language' = 'en-US,en;q=0.5'
	# 'Cache-Control' = 'no-cache'
	# 'Cookie' = '_fbp=fb.1.1638700781724.2075352598'
	# 'Host' = 'services.gradle.org'
	# 'Pragma' = 'no-cache'
	# 'Sec-Fetch-Dest' = 'document'
	# 'Sec-Fetch-Mode' = 'navigate'
	# 'Sec-Fetch-Site' = 'cross-site'
	# 'Upgrade-Insecure-Requests' = '1'
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls13
$Json = Invoke-RestMethod -Uri "https://services.gradle.org/versions/current" -Headers $Headers

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