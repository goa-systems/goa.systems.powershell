$ConfigFile = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if(Test-Path -Path $ConfigFile){
    Copy-Item -Path $ConfigFile -Destination "$env:TEMP\settings.wt.backup.json"
}
Get-AppxPackage | Where-Object {$_.Name -like "*Terminal*"} | Remove-AppxPackage