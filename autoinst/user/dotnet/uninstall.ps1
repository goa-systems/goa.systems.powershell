Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\.NET"
$Path = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::User)
$DotnetHome = [System.Environment]::GetEnvironmentVariable('DOTNET_HOME', [System.EnvironmentVariableTarget]::User)
$DotnetHome =  $DotnetHome -replace "\\","\\"
$Path = ($Path.Split(';') | Where-Object { $_ -notmatch "$DotnetHome" }) -join ';'
[System.Environment]::SetEnvironmentVariable('PATH', $Path, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('DOTNET_HOME', $null, [System.EnvironmentVariableTarget]::User)