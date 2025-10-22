function Get-Version {
	$VersionData = Invoke-RestMethod -Uri "https://windows.php.net/downloads/releases/releases.json"
	$HighestVersion = 0.0
	$PackageType = ""
	$VersionData.psobject.properties.name | ForEach-Object {
		if ($_ -gt $HighestVersion) {
			$HighestVersion = $_
		}
	}
	$VersionData.$HighestVersion.psobject.Properties.name | ForEach-Object {
		if($_ -match '^ts-vs\d+-x64$'){
			$PackageType += $_
		}
	}

	$VD = @{
		Version = $VersionData.$HighestVersion.version;
		File = $VersionData.$HighestVersion.$PackageType.zip.path
	}

	return $VD
}

Set-Location -Path "$PSScriptRoot"

$VersionData = Get-Version
$PhpZip = $VersionData.File
$TmpDir = "${env:TEMP}\$(New-Guid)"
$TargetDir = "${env:LocalAppData}\Programs\Php\$($VersionData.Version)"

if(Test-Path "${TmpDir}"){
	Remove-Item -Recurse -Force -Path "${TmpDir}"
}
New-Item -ItemType "Directory" -Path "${TmpDir}"

if( -not (Test-Path "${TargetDir}")){
	New-Item -ItemType "Directory" -Path "${TargetDir}"
}

$ProgressPreference = 'SilentlyContinue'
$PhpDownloadUrl = "https://windows.php.net/downloads/releases/${PhpZip}"
Write-Host -Object "Starting php download from ${PhpDownloadUrl}"
Invoke-WebRequest -Uri ${PhpDownloadUrl} -OutFile "${TmpDir}\${PhpZip}"
Write-Host -Object "Php download done."

Expand-Archive -Path "${TmpDir}\${PhpZip}" -DestinationPath "${TargetDir}"

[System.Environment]::SetEnvironmentVariable("PHP_HOME", "${TargetDir}", [System.EnvironmentVariableTarget]::User)