if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$DownloadUrl = $Json.url
	$TempDir = "${env:TEMP}\$(New-Guid)"
	
	<# Download Gimp, if setup is not found in execution path. #>
	if (Test-Path -Path "${TempDir}"){
		Remove-Item -Recurse -Force -Path "${TempDir}"
	}
	New-Item -ItemType "Directory" -Path "${TempDir}"
	
	Start-BitsTransfer `
		-Source  "$DownloadUrl"`
		-Destination "${TempDir}"

	Get-ChildItem -Path "${TempDir}" | ForEach-Object {
		Start-Process -Wait -FilePath "$($_.FullName)" -ArgumentList "/SILENT","/NORESTART","/ALLUSERS","/DIR=`"${env:PROGRAMFILES}\Gimp`""
	}

	Remove-Item -Recurse -Force -Path "${TempDir}"

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}