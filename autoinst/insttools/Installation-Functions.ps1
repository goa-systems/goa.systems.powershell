function New-Shortcut {
	param (
		# Name of the shortcut file (.lnk file)
		[string]
		$LinkName = "MyLink",
	
		# Target of shortcut (exe file where it points to)
		[string]
		$TargetPath = "%windir%\explorer.exe",
	
		# Target of shortcut (exe file where it points to)
		[string]
		$Arguments = "",
	
		# Icon file. Can be a executable, ico file or something else
		[string]
		$IconFile = "%windir%\explorer.exe",
	
		# Id of icon in icon file (defaults to 0)
		[int]
		$IconId = 0,
	
		# Description in the "Comment" field
		[string]
		$Description = "My link description",
	
		# Where should the executable get executed
		[string]
		$WorkingDirectory = "%USERPROFILE%",

		# Directories where the shortcut should be created
		[String[]] $ShortcutLocations = @("${env:UserProfile}\Desktop")
	)
	
	foreach ($ShortcutLocation in $ShortcutLocations) {
		$Shell = New-Object -ComObject ("WScript.Shell")
		$ShortCut = $Shell.CreateShortcut("${ShortcutLocation}\${LinkName}.lnk")
		$ShortCut.TargetPath = "${TargetPath}"
		$ShortCut.Arguments = "${Arguments}"
		$ShortCut.WorkingDirectory = "${WorkingDirectory}";
		$ShortCut.WindowStyle = 1;
		$ShortCut.Hotkey = "";
		$ShortCut.IconLocation = "${IconFile}, ${IconId}";
		$ShortCut.Description = "${Description}";
		$ShortCut.Save()
	}
}

function Get-LatestRelease {
	[CmdletBinding()]
	param (
		# Project owner
		[Parameter()]
		[string]
		$Owner,

		# Project name
		[Parameter()]
		[string]
		$Project
	)

	$Uri = "https://api.github.com/repos/${Owner}/${Project}/releases/latest"
	$Latest = Invoke-RestMethod -Uri "${Uri}"
	return $Latest
}