if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$peazipvers = "7.1.0"
	$peazipsetup = "peazip-$peazipvers.WIN64.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\peazip")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\peazip" -ItemType "Directory"
	}

	<# Download peazip scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\peazip\$peazipsetup")){
		$ProgressPreference = 'SilentlyContinue'
		$uri = "https://www.peazip.org/downloads/$peazipsetup"
		Invoke-WebRequest `
		-Uri "$uri" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\peazip\$peazipsetup"
	}

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\peazip\$peazipsetup" -ArgumentList "/SILENT"

	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\PeaZip") -ne $true) {
		New-Item "HKLM:\SOFTWARE\Classes\*\shell\PeaZip" -force -ea SilentlyContinue
	}

	if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\PeaZip\command") -ne $true) {
		New-Item "HKLM:\SOFTWARE\Classes\*\shell\PeaZip\command" -force -ea SilentlyContinue
	}

	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\PeaZip' -Name 'SubCommands' -Value "PeaZip.ext2main; PeaZip.ext2here; PeaZip.ext2folder; PeaZip.ext2browseasarchive; PeaZip.ext2browsepath; PeaZip.add2separate; PeaZip.add2separate7z; PeaZip.add2separatezip; PeaZip.add2convert; PeaZip.analyze; " -PropertyType String -Force -ea SilentlyContinue
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\PeaZip' -Name 'MultiSelectModel' -Value "player" -PropertyType String -Force -ea SilentlyContinue
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\PeaZip' -Name 'Icon' -Value "`"C:\Program Files\PeaZip\peazip.exe`",0" -PropertyType String -Force -ea SilentlyContinue

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}