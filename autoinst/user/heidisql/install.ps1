$Location = Get-Location
Set-Location -Path "$PSScriptRoot"
$Json = Get-Content -Path "version.json" -Raw | ConvertFrom-Json
$Source = "https://www.heidisql.com/downloads/releases/HeidiSQL_$($Json.version)_64_Portable.zip"
$Destination = "$env:TEMP\$(New-Guid).zip"
$ExtDest = "$env:TEMP\$(New-Guid)"
New-Item -ItemType "Directory" -Path "$ExtDest"
Start-BitsTransfer -Source "$Source" -Destination "$Destination"
Expand-Archive -Path "$Destination" -DestinationPath "$ExtDest"
Write-Host -Object "Extracted to $ExtDest"
Set-Location -Path "$Location"
$InstallPath = "$env:LocalAppData\Programs\HeidiSQL"
if(-Not (Test-Path -Path "$InstallPath")){
    New-Item -ItemType "Directory" -Path "$InstallPath"
}
Move-Item -Path "$ExtDest" -Destination "$InstallPath\$($Json.version)"

$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut("$env:AppData\Microsoft\Windows\Start Menu\Programs\HeidiSQL.lnk")
$ShortCut.TargetPath = "$InstallPath\$($Json.version)\heidisql.exe"
$ShortCut.Arguments = ""
$ShortCut.WorkingDirectory = "%UserProfile%";
$ShortCut.WindowStyle = 1;
$ShortCut.Hotkey = "";
$ShortCut.IconLocation = "$InstallPath\$($Json.version)\heidisql.exe, 0";
$ShortCut.Description = "HeidiSQL";
$ShortCut.Save()

Remove-Item -Path "$Destination"