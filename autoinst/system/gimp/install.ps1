if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	function Get-LatestVersion {
		$VersionsUrl = "https://www.gimp.org/gimp_versions.json"
		$VersionsObj = Invoke-RestMethod -Uri "${VersionsUrl}" -Method "GET"
		$LatestDate = Get-Date "1970-01-01"
		$Versions = @("","")

		$VersionsObj.STABLE | ForEach-Object {
			$Obj = $_
			$Obj.windows | ForEach-Object {
				if (-Not ([String]::IsNullOrEmpty($_.date))) {
					$Date = Get-Date $_.date
					if ($Date -gt $LatestDate) {
						$LatestDate = $Date
						$MinorVersion = $Obj.version
						$MinorVersion = $MinorVersion -split "\."
						$MinorVersion = "v$($MinorVersion[0]).$($MinorVersion[1])"
						$Versions[0] = $MinorVersion
						$Versions[1] = $_.filename
					}
				}
			}
		}
		return $Versions
	}

	Set-Location -Path "$PSScriptRoot"
	$VersArr = Get-LatestVersion
	$MinorVersion = $VersArr[0]
	$SetupFile = $VersArr[1]
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	if (Test-Path -Path "${DownloadDir}") {
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -ItemType "Directory" -Path "${DownloadDir}"
	$ProgressPreference = "SilentlyContinue"
	Write-Host -Object "Downloading ..."
	Invoke-WebRequest -Uri "https://download.gimp.org/gimp/${MinorVersion}/windows/${SetupFile}" -OutFile "${DownloadDir}\${SetupFile}"
	Write-Host -Object "Download finished."
	Start-Process -Wait -FilePath "${DownloadDir}\${SetupFile}" -ArgumentList @("/SILENT", "/MERGETASKS=`"!desktopicon`"", "/NORESTART", "/ALLUSERS", "/DIR=`"${env:PROGRAMFILES}\Gimp`"")
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}