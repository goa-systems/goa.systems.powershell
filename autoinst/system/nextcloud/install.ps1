if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"

	. ..\..\insttools\Installation-Functions.ps1

	$TagName = (Get-LatestRelease -Owner "nextcloud" -Project "desktop").tag_name
	$Version = $TagName.Substring(1)
	$SetupFile = "Nextcloud-${Version}-x64.msi"
	$Uri = "https://github.com/nextcloud-releases/desktop/releases/download/v${Version}/${SetupFile}"

	$TempDirectory = "${env:TEMP}\$(New-Guid)"
	if(Test-Path -Path "${TempDirectory}") {
		Remove-Item -Recurse -Force -Path "${TempDirectory}"
	}
	New-Item -ItemType "Directory" -Path "${TempDirectory}"

	<# Download openshot, if setup is not found in execution path. #>
	Write-Host -Object "Download started"
	$ProgressPreference = 'SilentlyContinue'
	Invoke-WebRequest -Uri "${Uri}" -OutFile "${TempDirectory}\${SetupFile}"
	Write-Host -Object "Download done"
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/i", "${TempDirectory}\${SetupFile}", "/passive", "/norestart")
	Remove-Item -Recurse -Force -Path "${TempDirectory}"

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}