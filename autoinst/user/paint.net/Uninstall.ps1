Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\Paint.NET"
[System.Environment]::SetEnvironmentVariable("PAINT_NET_HOME","", [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Paint.NET.lnk"){
    Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Paint.NET.lnk"
}