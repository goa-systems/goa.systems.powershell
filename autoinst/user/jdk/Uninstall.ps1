Get-ChildItem -Path "Env:\" | Where-Object {$_.Name -match "JAVA_HOME_.*" } | ForEach-Object {
    $InstallPath = "$($_.Value)"
    if (Test-Path -Path "${InstallPath}"){
        Remove-Item -Force -Recurse -Path "${InstallPath}"
    }
    [System.Environment]::SetEnvironmentVariable("$($_.Name)","", [System.EnvironmentVariableTarget]::User)
}