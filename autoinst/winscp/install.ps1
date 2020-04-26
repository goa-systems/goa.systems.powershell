if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	$vers = "5.17.4"
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
	$crlf = "`r`n"
	$IniFileContent = "[Setup]${crlf}Lang=en${crlf}Dir=C:\Program Files (x86)\WinSCP${crlf}Group=(Default)${crlf}NoIcons=0${crlf}SetupType=custom${crlf}Components=main,shellext,pageant${crlf}Tasks=enableupdates,urlhandler,searchpath${crlf}"
	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\winscp\winscp.ini" -Value $IniFileContent -NoNewline
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\winscp\$setup" -ArgumentList "/LOADINF=`"$env:SystemDrive\ProgramData\InstSys\winscp\winscp.ini`"","/SILENT","/ALLUSERS"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}