Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\RawTherapee"
[System.Environment]::SetEnvironmentVariable("RAWTHERAPEE_HOME","", [System.EnvironmentVariableTarget]::User)