Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk8\install.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk11\install.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk17\install.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk18\install.ps1") -Wait

[System.Environment]::SetEnvironmentVariable('JAVA_HOME',"$env:JAVA_HOME_18", [System.EnvironmentVariableTarget]::User)