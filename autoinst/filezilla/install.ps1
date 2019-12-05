
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	$fzsetup="FileZilla_3.46.0_win64-setup.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\filezilla" -ItemType "Directory"
	}
	
	<# Download Filezilla, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup")){
		$pattern= "<a href=`"(.*)`" rel=`"nofollow`">$fzsetup</a>"
		Invoke-WebRequest -Uri "https://filezilla-project.org/download.php?show_all=1" -OutFile "$env:TEMP\fzdl.html"
		$dllink = (Select-String -Path "$env:TEMP\fzdl.html" -Pattern $pattern).Matches.Groups[1].Value.Trim()
		Invoke-WebRequest -Uri $dllink -OutFile "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup"
		Remove-Item -Path "$env:TEMP\fzdl.html"
	}
	Start-Process -Wait `
		-FilePath "$env:SystemDrive\ProgramData\InstSys\filezilla\$fzsetup" `
		-ArgumentList "/S","/D=`"$env:PROGRAMFILES\FileZilla`""

} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}