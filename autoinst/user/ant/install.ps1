$Version = (ConvertFrom-Json -InputObject (Get-Content -Raw -Path "$PSScriptroot\version.json")).version
$DownloadDir = "$env:TEMP\$(New-Guid)"
New-Item -ItemType "Directory" -Path "$DownloadDir"
$DestinationFile = "apache-ant-${Version}-bin.zip"
$InstallRoot = "$env:LocalAppData\Programs\Ant"
Start-BitsTransfer -Source "https://dlcdn.apache.org//ant/binaries/$DestinationFile" -Destination "$DownloadDir\$DestinationFile"
if(-Not (Test-Path "$InstallRoot")){New-Item -ItemType "Directory" -Path "$InstallRoot"}
Expand-Archive -Path "$DownloadDir\$DestinationFile" -DestinationPath "$InstallRoot"
Remove-Item -Recurse -Force $DownloadDir
Get-ChildItem -Path "$InstallRoot" | ForEach-Object {
    [System.Environment]::SetEnvironmentVariable("ANT_HOME", "$($_.FullName)", [System.EnvironmentVariableTarget]:: User)
}