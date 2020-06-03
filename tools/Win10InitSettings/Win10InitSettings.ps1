function Test-RegistryValue {

	param (
		# Parameter help description
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Path,
		# Parameter help description
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Key
	)

	try {
		Get-ItemProperty -Path "$Path" | Select-Object -ExpandProperty "$Key" -ErrorAction Stop | Out-Null
		return $true	
	} catch {
		return $false
	}
}

function Set-RegValue {

	param (
		# Parameter help description
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Path,
		# Parameter help description
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Key,
		# Parameter help description
		[Parameter(Mandatory=$true)]
		$Value,
		# Parameter help description
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Type
	)
	
	<# First check, if the path exists. If not, create it. #>
	If( -Not (Test-Path -Path "$Path" -PathType Container) ){
		Write-Host "Warning: Path does not exist and will be created."
		New-Item -Path "$Path" -Force
	}

	If (Test-RegistryValue -Path $Path -Key $Key) {
		Write-Host "The key $key of type $Type exists and will be updated to $Value in [$Path]"
		If([string]::IsNullOrEmpty($value)){
			Clear-ItemProperty -Path $Path -Name $Key
		} else {
			Set-ItemProperty -Path $Path -Name $Key -Value $Value
		}
		
	} Else {
		Write-Host "The key $key of type $Type does not exist and will be created and set to $Value in [$Path]"
		New-ItemProperty -Path $Path -Name $Key -Value $Value -PropertyType $Type
	}
}

function Set-PSFontSize {
	param (
		# Path to powerhell shortcut
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[String]
		$Path
	)
	$bytes = [System.IO.File]::ReadAllBytes($Path)

	for ($i = 0; $i -lt $bytes.Length; $i++) {
		if($bytes[$i] -eq 0x0E){
			Write-Host -Object "Found font size 14 on position $i. Changing to 16."
			$bytes[$i] = 0x10
		}
	}
	[System.IO.File]::WriteAllBytes($Path, $bytes)
}

<# Settings applied to local machine #>

# Disable slide up lock screen
Set-RegValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"    -Key "NoLockScreen"                -Value 1   -Type "DWord"
Set-RegValue -Path "HKLM:\Software\Policies\Microsoft\Windows\System"             -Key "DisableLogonBackgroundImage" -Value 1   -Type "DWord"
Set-RegValue -Path "HKLM:\Software\Policies\Microsoft\Windows\System"             -Key "AllowDomainPINLogon"         -Value 1   -Type "DWord"
Set-RegValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Key "HiberbootEnabled"            -Value 0   -Type "DWord"

<# Settings applied to current user and all users which are going to be created in the future #>
$hive = "HKLM\DEFAULT"
$profiles = @("HKLM:\DEFAULT", "HKCU:")

& REG LOAD $hive "$env:SystemDrive\Users\Default\NTUSER.DAT"

foreach ($profile in $profiles) {

	# Launch Explorer to "This PC".
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "LaunchTo"                                -Value 1                                             -Type "DWord"

	# Disable animations".
	Set-RegValue -Path "$profile\Control Panel\Desktop\WindowMetrics"                                                   -Key "MinAnimate"                              -Value 0                                             -Type "String"
	
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "LaunchTo"                                -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "HideFileExt"                             -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "Hidden"                                  -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "TaskbarAnimations"                       -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                           -Key "ShowTaskViewButton"                      -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"                    -Key "PeopleBand"                              -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"  -Key "{645FF040-5081-101B-9F08-00AA002F954E}"  -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"     -Key "{645FF040-5081-101B-9F08-00AA002F954E}"  -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"  -Key "{018D5C66-4533-4307-9B53-224DE2ED1FE6}"  -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"     -Key "{018D5C66-4533-4307-9B53-224DE2ED1FE6}"  -Value 1                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"                      -Key "VisualFXSetting"                         -Value 3                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"                                    -Key "ShowRecent"                              -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"                                    -Key "ShowFrequent"                            -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"                                      -Key "SearchboxTaskbarMode"                    -Value 0                                             -Type "DWord"
	Set-RegValue -Path "$profile\Control Panel\Desktop\WindowMetrics"                                                   -Key "IconSpacing"                             -Value "-1125"                                       -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Desktop\WindowMetrics"                                                   -Key "IconVerticalSpacing"                     -Value "-1125"                                       -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "DragFullWindows"                         -Value "1"                                           -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "FontSmoothing"                           -Value "2"                                           -Type "String"
	Set-RegValue -Path "$profile\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe"                   -Key "FaceName"                                -Value "Consolas"                                    -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Colors"                                                                  -Key "Background"                              -Value "59 110 165"                                  -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "WallPaper"                               -Value ""                                            -Type "String"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers"                         -Key "CurrentWallpaperPath"                    -Value "C:\Windows\web\wallpaper\Windows\img0.jpg"   -Type "String"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "LogPixels"                               -Value 96                                            -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                             -Key "StartColorMenu"                          -Value 0xff333536                                    -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                             -Key "AccentColorMenu"                         -Value 0xff484a4c                                    -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"                             -Key "MinimizedStateTabletModeOff"             -Value 0x0                                           -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\DWM"                                                        -Key "AccentColor"                             -Value 0xff484a4c                                    -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\DWM"                                                        -Key "EnableWindowColorization"                -Value 0x1                                           -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\DWM"                                                        -Key "ColorizationAfterglow"                   -Value 0xc44c4a48                                    -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\DWM"                                                        -Key "ColorizationColor"                       -Value 0xc44c4a48                                    -Type "DWord"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\DWM"                                                        -Key "ColorPrevalence"                         -Value 0x1                                           -Type "DWord"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "JPEGImportQuality"                       -Value 0x64                                          -Type "DWord"
	<# Disable search suggestions in start menu starting with Windows 10, version 2004. #>
	Set-RegValue -Path "$profile\SOFTWARE\Policies\Microsoft\Windows\Explorer"                                          -Key "DisableSearchBoxSuggestions"             -Value 0x1                                           -Type "DWord"
	Set-RegValue -Path "$profile\Control Panel\Desktop"                                                                 -Key "UserPreferencesMask"                     -Value ([byte[]](0x90,0x00,0x03,0x80,0x10,0x00,0x00,0x00)) -Type "Binary"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                             -Key "AccentPalette"                           -Value ([byte[]](0x9B,0x9A,0x99,0x00,0x84,0x83,0x81,0x00,0x6D,0x6B,0x6A,0x00,0x4C,0x4A,0x48,0x00,0x36,0x35,0x33,0x00,0x26,0x25,0x24,0x00,0x19,0x19,0x19,0x00,0x10,0x7C,0x10,0x00)) -Type "Binary"
	Set-RegValue -Path "$profile\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"                             -Key "QatItems"                                -Value ([byte[]](0x3C,0x73,0x69,0x71,0x3A,0x63,0x75,0x73,0x74,0x6F,0x6D,0x55,0x49,0x20,0x78,0x6D,0x6C,0x6E,0x73,0x3A,0x73,0x69,0x71,0x3D,0x22,0x68,0x74,0x74,0x70,0x3A,0x2F,0x2F,0x73,0x63,0x68,0x65,0x6D,0x61,0x73,0x2E,0x6D,0x69,0x63,0x72,0x6F,0x73,0x6F,0x66,0x74,0x2E,0x63,0x6F,0x6D,0x2F,0x77,0x69,0x6E,0x64,0x6F,0x77,0x73,0x2F,0x32,0x30,0x30,0x39,0x2F,0x72,0x69,0x62,0x62,0x6F,0x6E,0x2F,0x71,0x61,0x74,0x22,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x72,0x69,0x62,0x62,0x6F,0x6E,0x20,0x6D,0x69,0x6E,0x69,0x6D,0x69,0x7A,0x65,0x64,0x3D,0x22,0x66,0x61,0x6C,0x73,0x65,0x22,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x71,0x61,0x74,0x20,0x70,0x6F,0x73,0x69,0x74,0x69,0x6F,0x6E,0x3D,0x22,0x30,0x22,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x73,0x68,0x61,0x72,0x65,0x64,0x43,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x73,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x36,0x31,0x32,0x38,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x66,0x61,0x6C,0x73,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x36,0x31,0x32,0x39,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x66,0x61,0x6C,0x73,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x35,0x32,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x66,0x61,0x6C,0x73,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x38,0x34,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x74,0x72,0x75,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x33,0x36,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x74,0x72,0x75,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x35,0x37,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x66,0x61,0x6C,0x73,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x30,0x31,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x74,0x72,0x75,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x73,0x69,0x71,0x3A,0x63,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x20,0x69,0x64,0x51,0x3D,0x22,0x73,0x69,0x71,0x3A,0x31,0x32,0x33,0x30,0x33,0x22,0x20,0x76,0x69,0x73,0x69,0x62,0x6C,0x65,0x3D,0x22,0x74,0x72,0x75,0x65,0x22,0x20,0x61,0x72,0x67,0x75,0x6D,0x65,0x6E,0x74,0x3D,0x22,0x30,0x22,0x20,0x2F,0x3E,0x3C,0x2F,0x73,0x69,0x71,0x3A,0x73,0x68,0x61,0x72,0x65,0x64,0x43,0x6F,0x6E,0x74,0x72,0x6F,0x6C,0x73,0x3E,0x3C,0x2F,0x73,0x69,0x71,0x3A,0x71,0x61,0x74,0x3E,0x3C,0x2F,0x73,0x69,0x71,0x3A,0x72,0x69,0x62,0x62,0x6F,0x6E,0x3E,0x3C,0x2F,0x73,0x69,0x71,0x3A,0x63,0x75,0x73,0x74,0x6F,0x6D,0x55,0x49,0x3E)) -Type "Binary"
}

while (!$unloaded -and ($attempts -le 5)) {
	[gc]::Collect()
	& REG UNLOAD $hive
	$unloaded = $?
	$attempts += 1
}
if (!$unloaded) {
	Write-Warning "Unable to dismount default user registry hive at HKLM\DEFAULT - manual dismount required"
}

# Set font size for current user and in second iteration for future users
foreach ($dir in @("$env:APPDATA", "$env:SystemDrive\Users\Default\AppData\Roaming")){
    Set-PSFontSize -Path "$dir\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
	Set-PSFontSize -Path "$dir\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell (x86).lnk"
}