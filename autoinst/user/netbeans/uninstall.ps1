$Processes = @("netbeans", "netbeans64")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 5

Write-Host -Object "Removing folder ..."
do {
	try {
		Remove-Item -Path "$env:LOCALAPPDATA\Programs\Netbeans" -Recurse -Force -ErrorAction Stop
		$ErrorOccured = $False
	} catch {
		$ErrorOccured = $True
		Start-Sleep -Seconds 4
	}
} while ($ErrorOccured)
Write-Host -Object "Folder removed."

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Netbeans"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Netbeans" -Recurse -Force
}