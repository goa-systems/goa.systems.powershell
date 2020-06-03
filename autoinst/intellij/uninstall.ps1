$Processes = @("idea", "idea64")
foreach($Process in $Processes){
	Write-Host -Object "Terminating process $Process"
	Get-Process -Name "$Process" -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 5

Write-Host -Object "Removing folder ..."
do {
	try {
		Remove-Item -Path "$env:LOCALAPPDATA\Programs\IntelliJ" -Recurse -Force -ErrorAction Stop
		$ErrorOccured = $False
	} catch {
		$ErrorOccured = $True
		Start-Sleep -Seconds 4
	}
} while ($ErrorOccured)
Write-Host -Object "Folder removed."

# Remove IntelliJ from path
$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
$NewPath = ""
foreach($pathvar in $pathvars){
	if( -not ($pathvar -like "*intellij*") -and -not [string]::IsNullOrEmpty($pathvar)){
		$NewPath += "${pathvar};"
	}
}
[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\IntelliJ"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\IntelliJ" -Recurse -Force
}

if(Test-Path -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\IntelliJ IDEA.lnk"){
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\IntelliJ IDEA.lnk" -Force
}

