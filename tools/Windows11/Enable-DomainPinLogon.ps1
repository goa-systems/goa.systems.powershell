if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if ( -not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System")) {
        New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowDomainPINLogon" -Value 1 -Type DWORD
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Verb RunAs
}