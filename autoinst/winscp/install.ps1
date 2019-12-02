$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	$vers = "5.15.7"
	$setup="WinSCP-$vers-Setup.exe"
	
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\winscp")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\winscp" -ItemType "Directory"
	}
	
	<# Download WinSCP, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\winscp\$setup")){
		Start-BitsTransfer `
		-Source "https://netcologne.dl.sourceforge.net/project/winscp/WinSCP/$vers/$setup" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\winscp\$setup"
	}
	
	$INI=@"
[Setup]
Lang=en
Dir=C:\Program Files (x86)\WinSCP
Group=(Default)
NoIcons=0
SetupType=custom
Components=main,shellext,pageant,puttygen
Tasks=enableupdates,urlhandler
"@

	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\winscp\winscp.ini" -Value $INI
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\winscp\$setup" -ArgumentList "/LOADINF=`"$env:SystemDrive\ProgramData\InstSys\winscp\winscp.ini`"","/SILENT"
	
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}