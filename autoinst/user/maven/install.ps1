$Version = (ConvertFrom-Json -InputObject (Get-Content -Raw -Path "$PSScriptroot\version.json")).version
$DownloadDir = "$env:TEMP\$(New-Guid)"
New-Item -ItemType "Directory" -Path "$DownloadDir"
$DestinationFile = "apache-maven-${Version}-bin.zip"
$InstallRoot = "$env:LocalAppData\Programs\Maven"
Start-BitsTransfer -Source "https://dlcdn.apache.org/maven/maven-3/${Version}/binaries/$DestinationFile" -Destination "$DownloadDir\$DestinationFile"
if(-Not (Test-Path "$InstallRoot")){New-Item -ItemType "Directory" -Path "$InstallRoot"}
Expand-Archive -Path "$DownloadDir\$DestinationFile" -DestinationPath "$InstallRoot"
Remove-Item -Recurse -Force $DownloadDir
Get-ChildItem -Path "$InstallRoot" | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable("MAVEN_HOME", "$($_.FullName)", [System.EnvironmentVariableTarget]:: User)
}