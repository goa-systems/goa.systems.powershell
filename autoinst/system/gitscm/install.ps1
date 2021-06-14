if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$uri = $Json.downloadurl
	$gitsetup = $Json.filename

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\git" -ItemType "Directory"
	}

	<# Download Git scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup")){
		$ProgressPreference = 'SilentlyContinue'
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
	Components=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,windowsterminal
	Tasks=
	EditorOption=VIM
	CustomEditorPath=
	DefaultBranchOption= 
	PathOption=Cmd
	SSHOption=OpenSSH
	TortoiseOption=false
	CURLOption=OpenSSL
	CRLFOption=CRLFCommitAsIs
	BashTerminalOption=MinTTY
	GitPullBehaviorOption=Merge
	UseCredentialManager=Core
	PerformanceTweaksFSCache=Enabled
	EnableSymlinks=Disabled
	EnablePseudoConsoleSupport=Disabled
	EnableFSMonitor=Disabled"

	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\git\$gitsetup" -ArgumentList "/SILENT","/LOADINF=$env:SystemDrive\ProgramData\InstSys\git\gitinst.inf"

} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}