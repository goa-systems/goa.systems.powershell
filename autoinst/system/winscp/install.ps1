if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Versions = @()
	$Response = Invoke-RestMethod -Uri "https://api.github.com/repos/winscp/winscp/tags"
	$Response| ForEach-Object {
		$Name = "" + $_.name
		if($Name -match '^(\d*)\.(\d*)\.(\d*)$'){
			$Versions += $_.name
		}
	}
	$Version = $Versions[0]
	$Setup="WinSCP-${Version}-Setup.exe"

	$DownloadPage = "https://winscp.net/download/WinSCP-${Version}-Setup.exe/download"
	$DownloadUrl = ""

	(Invoke-WebRequest -Uri "${DownloadPage}").Links | ForEach-Object {
		if($_.href -like "*-Setup.exe"){
			$DownloadUrl += $_.href
		}
	}
	
	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	
	<# Download Gimp, if setup is not found in execution path. #>
	if (Test-Path -Path "${DownloadDir}"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -ItemType "Directory" -Path "${DownloadDir}"
	
	<# Download WinSCP, if setup is not found in execution path. #>
	Start-BitsTransfer `
		-Source "${DownloadUrl}" `
		-Destination "${DownloadDir}\${Setup}"
	
	Start-Process -Wait -FilePath "${DownloadDir}\${Setup}" -ArgumentList @("/LOADINF=`"${PSScriptRoot}\install.ini`"", "/SILENT", "/ALLUSERS")
	
	Remove-Item -Recurse -Force -Path "${DownloadDir}"

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}