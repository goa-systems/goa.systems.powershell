if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	
	$Version = $Json.version
	$Setup="WinSCP-${Version}-Setup.exe"
	
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	
	<# Download Gimp, if setup is not found in execution path. #>
	if (Test-Path -Path "${DownloadDir}"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -ItemType "Directory" -Path "${DownloadDir}"
	
	<# Download WinSCP, if setup is not found in execution path. #>
	Start-BitsTransfer `
		-Source "https://netcologne.dl.sourceforge.net/project/winscp/WinSCP/${Version}/${Setup}" `
		-Destination "${DownloadDir}\${Setup}"
	
	Start-Process -Wait -FilePath "${DownloadDir}\${Setup}" -ArgumentList @("/LOADINF=`"${PSScriptRoot}\install.ini`"", "/SILENT", "/ALLUSERS")
	
	Remove-Item -Recurse -Force -Path "${DownloadDir}"

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}