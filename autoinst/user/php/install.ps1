Set-Location -Path "$PSScriptRoot"

$Version = (Get-Content -Path "version.json" -Raw | ConvertFrom-Json).version
$PhpZip = "php-$Version-Win32-vs16-x64.zip"
$TmpDir = "$env:TEMP\$(New-Guid)"
$TargetDir = "$env:LocalAppData\Programs\Php\$Version"

New-Item -ItemType "Directory" -Path "$TmpDir"

if( -not (Test-Path "$TargetDir")){
	New-Item -ItemType "Directory" -Path "$TargetDir"
}

$ProgressPreference = 'SilentlyContinue'
$PhpDownloadUrl = "https://windows.php.net/downloads/releases/$PhpZip"
Write-Host -Object "Starting php download from $PhpDownloadUrl"
Invoke-WebRequest -Uri $PhpDownloadUrl -OutFile "$TmpDir\$PhpZip"
Write-Host -Object "Php download done."

Expand-Archive -Path "$TmpDir\$PhpZip" -DestinationPath "$TargetDir"

[System.Environment]::SetEnvironmentVariable("PHP_HOME", "$TargetDir", [System.EnvironmentVariableTarget]::User)