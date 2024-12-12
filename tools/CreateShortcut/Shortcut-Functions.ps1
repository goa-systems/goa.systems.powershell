function New-Shortcut {
	param (
	# Name of the shortcut file (.lnk file)
	[String]
	$LinkName = "MyLink",

	# Target of shortcut (exe file where it points to)
	[String]
	$TargetPath = "${env:windir}\explorer.exe",

	# Target of shortcut (exe file where it points to)
	[String]
	$Arguments = "",

	# Icon file. Can be a executable, ico file or something else
	[String]
	$IconFile = "${env:windir}\explorer.exe",

	# Id of icon in icon file (defaults to 0)
	[int]
	$IconId = 0,

	# Description in the "Comment" field
	[String]
	$Description = "My link description",

	# Where should the executable get executed
	[String]
	$WorkingDirectory = "${env:USERPROFILE}",
	
	# Directories where the shortcut should be created
	[String[]] $ShortcutLocations = @(
		# "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs",
		"${env:USERPROFILE}\Desktop")
	)

	foreach($ShortcutLocation in $ShortcutLocations){
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