Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\WinMerge"
[System.Environment]::SetEnvironmentVariable("WINMERGE_HOME","", [System.EnvironmentVariableTarget]::User)
Remove-Itemproperty -Path "HKCU:\Environment" -Name "WINMERGE_HOME"