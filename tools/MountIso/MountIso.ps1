param (
	# Path to source iso. Can be relative.
	[Parameter(Mandatory=$true)]
	[String]
	$SourceIso
)

$fn = (Get-Item -Path "$SourceIso").FullName
$mr = Mount-DiskImage -ImagePath "$fn"
$dl = ($mr | Get-Volume).DriveLetter
Write-Host -Object "Iso $SourceIso mounted under ${dl}:\"