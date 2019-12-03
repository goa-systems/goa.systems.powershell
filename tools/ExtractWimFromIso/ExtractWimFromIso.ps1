param (
	# Path to source iso. Can be relative.
	[String]
	$SourceIso = "Windows.iso",
	
	# Index of image in source wim file
	[int]
	$SourceIndex = 1,

	# Target wim file
	[String]
	$TargetWim = "install.wim"
)

$fn = (Get-Item -Path "$SourceIso").FullName
$mr = Mount-DiskImage -ImagePath "$fn"
$dl = ($mr | Get-Volume).DriveLetter
$isowim = "${dl}:\sources\install.wim"
if( -Not (Test-Path -Path "$isowim")){
	$isowim = "${dl}:\sources\install.esd"
}
dism /export-image /sourceimagefile:"$isowim" /sourceindex:$SourceIndex /destinationimagefile:"$TargetWim"
$mr = Dismount-DiskImage -ImagePath "$fn"