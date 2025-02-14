Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\ImageGlass"
[System.Environment]::SetEnvironmentVariable("IMAGEGLASS_HOME","", [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\ImageGlass.lnk"){
    Remove-Item -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\ImageGlass.lnk"
}