& .\..\jdk8\install.ps1
& .\..\jdk11\install.ps1
& .\..\jdk17\install.ps1

[System.Environment]::SetEnvironmentVariable('JAVA_HOME',"$env:JAVA_HOME_17", [System.EnvironmentVariableTarget]::User)