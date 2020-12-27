if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$name="winmerge"
	$apptitle="WinMerge"
	$version = $Json.version
	$setup="winmerge-$version-x64-exe.zip"
	$dlurl="https://netcologne.dl.sourceforge.net/project/winmerge/stable/$version/$setup"
	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\$name" -ItemType "Directory"
	}
	
	<# Download, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup")) {
		Start-BitsTransfer -Source "$dlurl" -Destination "$env:SystemDrive\ProgramData\InstSys\$name\$setup"
	}
	
	Expand-Archive -Path "$env:SystemDrive\ProgramData\InstSys\$name\$setup" -DestinationPath "$env:ProgramFiles"
	
	$Shell = New-Object -ComObject ("WScript.Shell")
	$ShortCut = $Shell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\${apptitle}U.lnk")
	$ShortCut.TargetPath="$env:ProgramFiles\$apptitle\${apptitle}U.exe"
	$ShortCut.Arguments=""
	$ShortCut.WorkingDirectory = "%userprofile%";
	$ShortCut.WindowStyle = 1;
	$ShortCut.Hotkey = "";
	$ShortCut.IconLocation = "$env:ProgramFiles\$apptitle\${apptitle}U.exe, 0";
	$ShortCut.Description = "$apptitle";
	$ShortCut.Save()
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}