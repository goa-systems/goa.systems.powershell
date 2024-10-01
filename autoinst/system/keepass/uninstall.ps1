if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	if(Test-Path -Path "$env:ProgramFiles\KeePass") {
		Remove-Item -Path "$env:ProgramFiles\KeePass" -Recurse
	}
	
	if(Test-Path -Path "$env:Public\Desktop\KeePass.lnk") {
		Remove-Item -Path "$env:Public\Desktop\KeePass.lnk"
	}
	
	if(Test-Path -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\KeePass.lnk") {
		Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\KeePass.lnk"
	}
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}