$Processes = @("python")
foreach ($Process in $Processes) {
	$p = Get-Process "$Process" -ErrorAction SilentlyContinue
	if ($p) {
		"Process $p is running. Trying to stop it."
		$p | Stop-Process -Force
	}
	else {
		"Process $Process is not running."
	}
}

function Get-UninstString {

	param(
		# Parent regkey in which to search for the uninstall string
		[parameter(Mandatory=$true)]
		[String]
		$regkey
	)

	$var1 = Get-ChildItem -Path $regkey | Get-ItemProperty | Where-Object { $_.DisplayName -match "Python" }
	$var2 = $var1.QuietUninstallString
	return $var2
}

$regkeys = @(
	"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
)

foreach($regkey in $regkeys){
	$UninstallString = Get-UninstString -regkey $regkey

	if([string]::IsNullOrEmpty($UninstallString)){
		Write-Host -Object "Uninststring not found."
	} else {
		Write-Host -Object "Uninststring found $UninstallString"
		Invoke-Expression "& $UninstallString"
	}
}