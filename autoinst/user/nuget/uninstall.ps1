$AllInstDir = "$env:LocalAppData\Programs\NuGet"

# Try to stop all nuget processes
Stop-Process -Name "nuget" -ErrorAction SilentlyContinue

if(Test-Path -Path "$AllInstDir"){
    Remove-Item -Recurse -Force -Path "$AllInstDir"
}

[System.Environment]::SetEnvironmentVariable("NUGET_HOME", $null, [System.EnvironmentVariableTarget]::User)