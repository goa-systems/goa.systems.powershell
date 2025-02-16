if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"

	. ..\..\insttools\Installation-Functions.ps1

	$SetupFile = ""
	$Uri = ""
	$LatestRelease = Get-LatestRelease -Owner "ShareX" -Project "ShareX"
	$LatestRelease.assets | ForEach-Object {
		if($_.name -match "^ShareX-.*-setup\.exe$"){
			$SetupFile += $_.name
			$Uri += $_.browser_download_url
		}
	}

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

	Start-Process -Wait -FilePath "${TempDirectory}\${SetupFile}" -ArgumentList "/SILENT","/NORUN"
	
	Remove-Item -Recurse -Force -Path "${TempDirectory}"
	
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}