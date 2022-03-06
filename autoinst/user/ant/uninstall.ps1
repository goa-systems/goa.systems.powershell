$processes = @("java", "javaw")
foreach($process in $processes){
	Get-Process -Name "$process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}
$InstallRoot = "$env:LocalAppData\Programs\Ant"
Remove-Item -Recurse -Force -Path "$InstallRoot"