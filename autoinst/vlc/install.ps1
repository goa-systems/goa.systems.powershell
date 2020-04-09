if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$registryPath = "HKLM:\SOFTWARE\VideoLAN\VLC"
	$registryKey = "InstallDir"
	$registryVal = "$env:ProgramFiles\VLC Media Player"
	
	if (Test-Path $registryPath) {
		Write-Host "Writing value only."
		New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryVal -PropertyType "String" -Force
	} else {
		Write-Host "Creating registry path first."
		New-Item -Path $registryPath -Force
		New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryVal -PropertyType "String" -Force
	}
	
	$vlcvers = "3.0.9.2"
	$vlcsetup = "vlc-$vlcvers-win64.exe"
	
	If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\vlc")){
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\vlc" -ItemType "Directory"
	}
	
	<# Download Libreoffice, if setup is not found in execution path. #>
	if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\vlc\$vlcsetup")){
		Start-BitsTransfer `
		-Source "http://ftp.videolan.org/vlc/$vlcvers/win64/$vlcsetup" `
		-Destination "$env:SystemDrive\ProgramData\InstSys\vlc\$vlcsetup"
	}
	
	Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\vlc\$vlcsetup" -ArgumentList "/S"
	Remove-Item -Recurse "$env:SystemDrive\Users\Public\Desktop\VLC media player.lnk"
	
	$dirs = @(
		"$env:SystemDrive\Users\Default\Appdata\Roaming\Vlc",
		"$env:AppData\Vlc"
	)
	
	foreach($dir in $dirs){
		if (Test-Path "$dir") {
			Remove-Item "$dir" -Recurse
		}
		Copy-Item -Path "vlc" -Destination "$dir" -Recurse
	}
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}