param (
	# Path to inkscape
    [String] $InkscapeExe = "C:\Program Files\Inkscape\bin\inkscape.exe",
    
	# Src svg filename
    [Parameter(Mandatory=$true)] [String] $SourceName,
    
	# Destination folder
	[String] $DestinationFolder = "output"
)

if(-not (Test-Path "$DestinationFolder")){
	New-Item -ItemType Directory -Path "$DestinationFolder"
}

$Sizes = @("256", "192", "128", "96", "64", "48", "32", "24", "16", "12", "8")
foreach($Size in $Sizes){
	Start-Process -FilePath "$InkscapeExe" -ArgumentList @("--export-type=`"png`"", "--export-filename","$DestinationFolder\$Size.png","-w","$Size","-h","$Size","$SourceName")
}