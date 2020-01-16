Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Get-ChildItem -Path "." -Recurse | Where-Object { $_.Name -match "(.*)\.ps1"} | ForEach-Object {
	$FullPath = $_.FullName
	Write-Host -Object "Unblocking file $FullPath"
	Unblock-File -Path $FullPath
}