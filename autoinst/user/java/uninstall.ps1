& $PSScriptRoot\..\jdk8\uninstall.ps1
& $PSScriptRoot\..\jdk11\uninstall.ps1
& $PSScriptRoot\..\jdk17\uninstall.ps1

[System.Environment]::SetEnvironmentVariable('JAVA_HOME',$null, [System.EnvironmentVariableTarget]::User)