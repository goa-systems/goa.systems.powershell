[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $EclipseInstallDir = "${env:ECLIPSE_HOME}"
)

if (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse") {
    Remove-Item -Recurse -Force -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Eclipse"
}

if (Test-Path -Path "${EclipseInstallDir}") {
    Remove-Item -Recurse -Force "${EclipseInstallDir}"
    [System.Environment]::SetEnvironmentVariable("ECLIPSE_HOME", "", [System.EnvironmentVariableTarget]::User)
    Remove-Itemproperty -Path "HKCU:\Environment" -Name "ECLIPSE_HOME"
}