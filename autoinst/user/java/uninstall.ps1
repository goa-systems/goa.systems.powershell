Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk8\uninstall.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk11\uninstall.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk17\uninstall.ps1") -Wait
Start-Process -FilePath "pwsh" -ArgumentList @("-File", "$PSScriptRoot\..\jdk18\uninstall.ps1") -Wait

[System.Environment]::SetEnvironmentVariable('JAVA_HOME',$null, [System.EnvironmentVariableTarget]::User)