param (
	[String]
    $ApacheVersion = "2.4.49"
)

if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Stop-Service -DisplayName "Apache web server" -Force
    Start-Process -FilePath "$env:ProgramFiles\Apache\$ApacheVersion\bin\httpd.exe" -ArgumentList @("-k","uninstall","-n","`"Apache web server`"") -Wait
    Remove-Item -Path "$env:ProgramFiles\Apache\$ApacheVersion" -Recurse

    <# If there are no more Apache versions installed, remove directory. #>
    if((Test-Path -Path "$env:ProgramFiles\Apache") -and (Get-ChildItem "$env:ProgramFiles\Apache" | Measure-Object).Count -eq 0){
        Remove-Item -Path "$env:ProgramFiles\Apache"
    }
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-ApacheVersion","`"$ApacheVersion`"" -Wait -Verb RunAs
}