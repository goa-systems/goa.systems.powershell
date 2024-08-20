Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\.NET"
Write-Host -Object "Please remove %DOTNET_HOME% manually from path."