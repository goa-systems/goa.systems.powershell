if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$subversion=".1"
	$gitvers = "2.28.0"
	$gitsetup = "Git-$gitvers-64-bit.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\git" -ItemType "Directory"
	}

	<# Download Git scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup")){
		$ProgressPreference = 'SilentlyContinue'
		$uri = "https://github.com/git-for-windows/git/releases/download/v$gitvers.windows$subversion/$gitsetup"
		Invoke-WebRequest `
		-Uri "$uri" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup"
	}

	Set-Content -Path "$env:SystemDrive\ProgramData\InstSys\git\gitinst.inf" -Value "[Setup]
	Lang=default
	Dir=C:\Program Files\Git
	Group=Git
	NoIcons=0
	SetupType=default
	Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh
	Tasks=
	EditorOption=VIM
	CustomEditorPath=
	PathOption=Cmd
	SSHOption=OpenSSH
	TortoiseOption=false
	CURLOption=OpenSSL
	CRLFOption=CRLFCommitAsIs
	BashTerminalOption=MinTTY
	PerformanceTweaksFSCache=Enabled
	UseCredentialManager=Enabled
	EnableSymlinks=Disabled"

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup" -ArgumentList "/SILENT","/LOADINF=$env:SystemDrive\ProgramData\InstSys\git\gitinst.inf"

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}