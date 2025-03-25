if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

	Set-Location -Path "$PSScriptRoot"

	$GitSetup = ""
	$Uri = ""

	(Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest").assets | ForEach-Object {
		if($_.name -match ".*64-bit\.exe"){
			$GitSetup += $_.name
			$Uri += $_.browser_download_url
		}
	}

	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\git" -ItemType "Directory"
	}

	<# Download Git scm, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\git\${GitSetup}")){
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest `
		-Uri "${Uri}" `
		-OutFile "$env:SystemDrive\ProgramData\InstSys\git\${GitSetup}"
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
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}
