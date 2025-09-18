. "${PSScriptRoot}\Functions.ps1"

$VersionsToInstall = @("25", "24" ,"21","17","11","8")

$VersionsToInstall | ForEach-Object { Install-Java -JavaMajorVersion "$($_)" }

$env:JAVA_HOME = "%JAVA_HOME_$($VersionsToInstall[0])%"
Set-ItemProperty -Path "HKCU:\Environment" -Name "JAVA_HOME" -Value "${env:JAVA_HOME}" -Type "ExpandString"