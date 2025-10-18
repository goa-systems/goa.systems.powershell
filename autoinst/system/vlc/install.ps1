if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	
	function Get-Version {
		$BaseUrl = "https://download.videolan.org/pub/videolan/vlc/"
		$Response = Invoke-WebRequest -Uri $BaseUrl
		$Versions = ($Response.Links | Where-Object { $_.href -match '^\d+\.\d+(\.\d+)?/$' }).href ` | ForEach-Object { $_.TrimEnd('/') }
		$ParsedVersions = $Versions | ForEach-Object { [version]$_ }
		$Latest = $parsedVersions | Sort-Object -Descending | Select-Object -First 1
		return $Latest.ToString()
	}

	Set-Location -Path "$PSScriptRoot"	
	$registryPath = "HKLM:\SOFTWARE\VideoLAN\VLC"
	$registryKey = "InstallDir"
	$registryVal = "$env:ProgramFiles\VLC Media Player"

	$TempDir = "${env:TEMP}\$(New-Guid)"

	if (Test-Path  -Path "${TempDir}") {
		Remove-Item -Recurse -Force -Path "${TempDir}"
	}
	New-Item -Path "${TempDir}" -ItemType "Directory"
	
	if (Test-Path $registryPath) {
		Write-Host "Writing value only."
		New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryVal -PropertyType "String" -Force
	} else {
		Write-Host "Creating registry path first."
		New-Item -Path $registryPath -Force
		New-ItemProperty -Path $registryPath -Name $registryKey -Value $registryVal -PropertyType "String" -Force
	}

	$vlcvers = Get-Version
	$VlcSetup = "vlc-$vlcvers-win64.exe"
	Start-BitsTransfer -Source "http://ftp.videolan.org/vlc/$vlcvers/win64/${VlcSetup}" -Destination "${TempDir}\${VlcSetup}"

	Start-Process -Wait -FilePath "${TempDir}\${VlcSetup}" -ArgumentList "/S"
	Remove-Item -Recurse "$env:SystemDrive\Users\Public\Desktop\VLC media player.lnk"

	$dirs = @(
		"${env:SystemDrive}\Users\Default\Appdata\Roaming\Vlc",
		"${env:APPDATA}\Vlc"
	)

	foreach ($Dir in $Dirs) {
		if (Test-Path "$Dir") {
			Remove-Item "$Dir" -Recurse
		}
		Copy-Item -Path "vlc" -Destination "$Dir" -Recurse
	}

	Remove-Item -Recurse -Force -Path "${TempDir}"
}
else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}