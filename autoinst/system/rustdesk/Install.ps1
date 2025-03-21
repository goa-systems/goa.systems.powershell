if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"

	$SetupFile = ""
	$Uri = ""
	$LatestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/rustdesk/rustdesk/releases/latest"
	$LatestRelease.assets | ForEach-Object {
		if($_.name -match "^rustdesk-.*-x86_64\.msi$"){
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

	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/i", "${TempDirectory}\${SetupFile}", "/qn", "CREATEDESKTOPSHORTCUTS=0")

	Remove-Item -Recurse -Force -Path "${TempDirectory}"
	
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}