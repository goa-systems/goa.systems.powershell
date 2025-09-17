. "${PSScriptRoot}\Functions.ps1"

@("25","21","17","11","8") | ForEach-Object { Install-Java -JavaMajorVersion "$($_)" }
