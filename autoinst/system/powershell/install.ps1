if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$ApplicationName = "pwsh.exe"
	Set-Location -Path "$PSScriptRoot"
	$LatestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
	$Version = $LatestRelease.tag_name.Substring(1)
	$SetupFile = "PowerShell-${Version-win-x64}.msi"
	$DownloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v${Version}/${SetupFile}"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$ApplicationName")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$ApplicationName" -ItemType "Directory"
	}

	<# Download if setup is not found in execution path. #>
	$ProgressPreference = 'SilentlyContinue'
		
	if ( -Not (Test-Path -Path "$env:SystemsDrive\ProgramData\InstSys\$ApplicationName\$SetupFile")) {
		Write-Host "Downloading from $DownloadUrl"
		Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$env:SystemDrive\ProgramData\InstSys\$ApplicationName\$SetupFile"
	}
	Start-Process -FilePath "msiexec" -ArgumentList @("/package","$env:SystemDrive\ProgramData\InstSys\$ApplicationName\$SetupFile","/passive","ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1", "ENABLE_PSREMOTING=1", "REGISTER_MANIFEST=1", "USE_MU=1", "ENABLE_MU=1")
	try {
		Stop-Process -Name "pwsh" -ErrorAction SilentlyContinue
	}
	catch {}
}
else {
	Start-Process -FilePath "powershell.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}