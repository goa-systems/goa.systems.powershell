if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	function Get-Version {
		$ParsedVersion = ""
		((Invoke-WebRequest -Uri "https://build.openvpn.net/downloads/releases/latest/LATEST.txt") -split "\r\n") | ForEach-Object {
			$Line = $_
			if ($Line -match 'OpenVPN stable installer version: (.*)') {
				$ParsedVersion += $matches[1]
			}
		}

		return $ParsedVersion
	}

	Set-Location -Path "$PSScriptRoot"
	$Setup = "OpenVPN-$(Get-Version)-amd64.msi"
	$DownloadUrl = "https://swupdate.openvpn.org/community/releases/${Setup}"
	
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	If (Test-Path -Path "${DownloadDir}") {
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -Path "${DownloadDir}" -ItemType "Directory"

	Write-Host "Downloading from ${DownloadUrl}"
	Start-BitsTransfer -Source ${DownloadUrl} -Destination "${DownloadDir}\${Setup}"
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/passive", "/i", "`"${DownloadDir}\${Setup}`"")

	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}
else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}