Set-Location -Path "${PSScriptRoot}"
$DownloadDir = "${env:TEMP}\$(New-Guid)"
$ProgressPreference = "SilentlyContinue"
if(Test-Path -Path "${DownloadDir}"){
    Remove-Item -Force -Recurse -Path "${DownloadDir}"
}
New-Item -ItemType "Directory" -Path "${DownloadDir}"

$MainVersion = ""

Get-Content -Path "${PSScriptRoot}\version.json" | ConvertFrom-Json | ForEach-Object {
    if ($_.main) {
        $MainVersion = $_.version
        Invoke-WebRequest -Uri "$($_.package)" -OutFile "${DownloadDir}\$($_.version).zip" -UserAgent $UserAgent
        New-Item -ItemType "Directory" -Path "${env:LOCALAPPDATA}\Programs\.NET\${MainVersion}"
        Expand-Archive -Path "${DownloadDir}\$($_.version).zip" -DestinationPath "${env:LOCALAPPDATA}\Programs\.NET\${MainVersion}"
        [System.Environment]::SetEnvironmentVariable("DOTNET_HOME", "${env:LOCALAPPDATA}\Programs\.NET\${MainVersion}", [System.EnvironmentVariableTarget]::User)
        $env:DOTNET_HOME = "${env:LOCALAPPDATA}\Programs\.NET\${MainVersion}"
    }
}

Get-Content -Path "${PSScriptRoot}\version.json" | ConvertFrom-Json | ForEach-Object {
    if ( -Not $_.main) {
        Invoke-WebRequest -Uri "$($_.package)" -OutFile "${DownloadDir}\$($_.version).zip" -UserAgent $UserAgent
        Expand-Archive -Path "${DownloadDir}\$($_.version).zip" -DestinationPath "${DownloadDir}\$($_.version)"
        Move-Item -Path "${DownloadDir}\$($_.version)\sdk\$($_.version)" -Destination "${env:LOCALAPPDATA}\Programs\.NET\${MainVersion}\sdk\$($_.version)"
    }
}

Write-Host -Object "Removing ${DownloadDir}"
Remove-Item -Recurse -Force -Path "${DownloadDir}"