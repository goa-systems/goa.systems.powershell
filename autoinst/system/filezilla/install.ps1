
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json

	$FilezillaSetup="FileZilla_$($Json.version)_win64-setup.exe"
	$DownloadUrl = "https://download.filezilla-project.org/client/$FilezillaSetup"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\filezilla" -ItemType "Directory"
	}
	
	<# Download Filezilla, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla\$FilezillaSetup")){
		Write-Host -Object "Downloading FileZilla."
		$ProgressPreference = 'SilentlyContinue'
		$UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome
		Invoke-WebRequest -Uri $DownloadUrl -OutFile "$env:SystemDrive\ProgramData\InstSys\filezilla\$FilezillaSetup" -UserAgent $UserAgent
	}
	Start-Process -Wait `
		-FilePath "$env:SystemDrive\ProgramData\InstSys\filezilla\$FilezillaSetup" `
		-ArgumentList "/S","/D=`"$env:PROGRAMFILES\FileZilla`""

} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}