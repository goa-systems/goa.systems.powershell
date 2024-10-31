$InstallDir = "$env:LocalAppData\Programs\IntelliJ"
$Json = (Get-Content -Path "$PSScriptRoot\version.json" | ConvertFrom-Json)
$FileName = "ideaIC-$($Json.version).win.zip"
$Url = "https://download.jetbrains.com/idea/$FileName"

$DownloadDir = "$env:Temp\$(New-Guid)"

if(Test-Path -Path "${DownloadDir}"){
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
New-Item -ItemType Directory -Path "${DownloadDir}"

if( -Not (Test-Path -Path "${InstallDir}")){
	New-Item -ItemType Directory -Path "${InstallDir}"
} elseif (Test-Path -Path "${InstallDir}\$($Json.version)"){
	Remove-Item -Recurse -Force -Path "${InstallDir}\$($Json.version)"
}

# Download IntelliJ
$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest -Uri "${Url}" -OutFile "${DownloadDir}\${FileName}"
$ProgressPreference = "Continue"
Expand-Archive -Path "${DownloadDir}\${FileName}" -DestinationPath "${InstallDir}\$($Json.version)"
[System.Environment]::SetEnvironmentVariable("IDEA_HOME", "${InstallDir}\$($Json.version)", [System.EnvironmentVariableTarget]::User)
