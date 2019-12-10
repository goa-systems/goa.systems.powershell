param (
	# Path to file
	[String]
	$Path = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk"
)
$bytes = [System.IO.File]::ReadAllBytes($Path)
for ($i = 0; $i -lt $bytes.Length; $i++) {
	if($bytes[$i] -eq 0x0E){
		Write-Host -Object "Found font size 14 on position $i. Changing to 16."
		$bytes[$i] = 0x10
	}
}
[System.IO.File]::WriteAllBytes($Path, $bytes)