Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\DBeaver"
[System.Environment]::SetEnvironmentVariable("DBEAVER_HOME","", [System.EnvironmentVariableTarget]::User)