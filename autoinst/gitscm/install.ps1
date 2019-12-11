$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	$subversion=".2"
	$gitvers = "2.24.1"
	$gitsetup = "Git-$gitvers$subversion-64-bit.exe"

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\git" -ItemType "Directory"
	}

	<# Download Git scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup")){
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
	EditorOption=Notepad++
	CustomEditorPath=
	PathOption=Cmd
	SSHOption=OpenSSH
	CURLOption=OpenSSL
	CRLFOption=CRLFAlways
	BashTerminalOption=MinTTY
	PerformanceTweaksFSCache=Enabled
	UseCredentialManager=Enabled
	EnableSymlinks=Disabled
	EnableBuiltinInteractiveAdd=Disabled"

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup" -ArgumentList "/SILENT","/LOADINF=$env:SystemDrive\ProgramData\InstSys\git\gitinst.inf"

} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$curscriptname" -Wait -Verb RunAs
}