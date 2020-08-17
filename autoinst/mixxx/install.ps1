if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$CurrentVersion = "2.2.4"
	$SetupFile = "mixxx-$CurrentVersion-win64.exe"
	$DownloadUrl = "https://downloads.mixxx.org/mixxx-$CurrentVersion/$SetupFile"
	$WorkingDir = "$env:ProgramData\InstSys\mixxx"
	if( -not (Test-Path -Path "$WorkingDir")){
		New-Item -ItemType "Directory" -Path "$WorkingDir"
	}
	if( -not (Test-Path -Path "$WorkingDir\$SetupFile")){
		$ProgressPreference = 'SilentlyContinue'
		Write-Host -Object "Downloading Mixxx"
		Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$WorkingDir\$SetupFile"
		Write-Host -Object "Download done"
	}
	Start-Process -Wait -FilePath "$WorkingDir\$SetupFile" -ArgumentList @("/S")
}
else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}