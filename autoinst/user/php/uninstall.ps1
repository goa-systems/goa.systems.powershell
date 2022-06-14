Remove-Item -Recurse -Force -Path "$env:LocalAppData\Programs\Php"
[System.Environment]::SetEnvironmentVariable("PHP_HOME", $null, [System.EnvironmentVariableTarget]::User)