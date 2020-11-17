
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json

	$fzsetup="FileZilla_$($Json.version)_win64-setup.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\filezilla" -ItemType "Directory"
	}
	
	<# Download Filezilla, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup")){
		$pattern= "<a href=`"(.*)`" rel=`"nofollow`">$fzsetup</a>"
		Invoke-WebRequest -Uri "https://filezilla-project.org/download.php?show_all=1" -OutFile "$env:TEMP\fzdl.html"
		$dllink = (Select-String -Path "$env:TEMP\fzdl.html" -Pattern $pattern).Matches.Groups[1].Value.Trim()
		Write-Host -Object "Downloading FileZilla."
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri $dllink -OutFile "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup"
		Remove-Item -Path "$env:TEMP\fzdl.html"
	}
	Start-Process -Wait `
		-FilePath "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup" `
		-ArgumentList "/S","/D=`"$env:PROGRAMFILES\FileZilla`""

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}