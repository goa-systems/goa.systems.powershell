Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\Bruno"
[System.Environment]::SetEnvironmentVariable("BRUNO_HOME","", [System.EnvironmentVariableTarget]::User)