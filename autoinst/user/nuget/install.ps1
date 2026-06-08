$Url = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$InstDir = "${env:LocalAppdata}\Programs\NuGet"
if(Test-Path "$InstDir") {
    Remove-Item -Recurse -Force -Path "$Instdir"
}
New-Item -ItemType "Directory" -Path "$InstDir"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$Url" -OutFile "$InstDir\nuget.exe"
[System.Environment]::SetEnvironmentVariable("NUGET_HOME", "$InstDir", [System.EnvironmentVariableTarget]::User)