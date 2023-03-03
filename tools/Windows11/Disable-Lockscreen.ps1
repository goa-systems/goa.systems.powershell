if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ( -not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
        New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "Nolockscreen" -Value 1 -Type DWORD
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}