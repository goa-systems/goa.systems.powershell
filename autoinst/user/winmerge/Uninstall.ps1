Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\WinMerge"
[System.Environment]::SetEnvironmentVariable("WINMERGE_HOME","", [System.EnvironmentVariableTarget]::User)