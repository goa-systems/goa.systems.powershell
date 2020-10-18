if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$name="keepass"
	$version="2.46"
	$setup="KeePass-$version.zip"
	$dlurl="https://netcologne.dl.sourceforge.net/project/keepass/KeePass%202.x/$version/$setup"
	
	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	
	<# Download, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")) {
		Invoke-WebRequest -Uri "$dlurl" -OutFile "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}
	
	Expand-Archive -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -DestinationPath "$env:ProgramFiles\KeePass"
	..\..\insttools\CreateShortcut.ps1 -LinkName "KeePass" -TargetPath "%ProgramFiles%\KeePass\KeePass.exe" -Arguments "" -IconFile "%ProgramFiles%\KeePass\KeePass.exe" -IconId 0 -Description "KeePass password safe." -WorkingDirectory "%UserProfile%" -ShortcutLocations @("$env:ProgramData\Microsoft\Windows\Start Menu\Programs")
	

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}