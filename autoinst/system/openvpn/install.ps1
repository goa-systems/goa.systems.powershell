if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$Setup = $Json.version
	$DownloadUrl = "https://swupdate.openvpn.org/community/releases/${Setup}"
	
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	If(Test-Path -Path "${DownloadDir}"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -Path "${DownloadDir}" -ItemType "Directory"

		Write-Host "Downloading from ${DownloadUrl}"
		Start-BitsTransfer -Source ${DownloadUrl} -Destination "${DownloadDir}\${Setup}"
	
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/passive", "/i", "`"${DownloadDir}\${Setup}`"")

	Remove-Item -Recurse -Force -Path "${DownloadDir}"
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}