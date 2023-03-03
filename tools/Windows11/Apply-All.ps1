if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    & "$PSScriptRoot\Disable-SearchInStartmenu.ps1"
    & "$PSScriptRoot\Enable-DomainPinLogon.ps1"
    & "$PSScriptRoot\Disable-Lockscreen.ps1"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}