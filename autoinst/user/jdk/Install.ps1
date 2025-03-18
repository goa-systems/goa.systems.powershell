. "${PSScriptRoot}\Functions.ps1"

@("24","21","17","11","8") | ForEach-Object { Install-Java -JavaMajorVersion "$($_)" }