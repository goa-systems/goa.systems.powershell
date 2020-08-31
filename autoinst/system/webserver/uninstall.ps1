if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Stop-Service -Name "Apache web server" -Force
	Start-Process "sc.exe" -ArgumentList "delete","Apachewebserver"
	if(Test-Path -Path "$env:ProgramFiles\Apache"){
		Remove-Item -Path "$env:ProgramFiles\Apache" -Recurse -Force
	}
	if(Test-Path -Path "$env:ProgramFiles\Php"){
		Remove-Item -Path "$env:ProgramFiles\Php" -Recurse -Force
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}