$Archive = "msys2-base-x86_64-20200629.tar.xz"
$Url = "http://repo.msys2.org/distrib/x86_64/$Archive"

if( -not (Test-Path -Path "$env:ProgramData\InstSys\Msys2")){
    New-Item -Path "$env:ProgramData\InstSys\Msys2" -ItemType "Directory"
}

if(Test-Path -Path "$env:TEMP\Msys2Inst"){
    Remove-Item "$env:TEMP\Msys2Inst" -Force -Recurse
}
New-Item -Path "$env:TEMP\Msys2Inst" -ItemType "Directory"

if( -not (Test-Path -Path "$env:ProgramData\InstSys\Msys2\$Archive")){
    Start-BitsTransfer -Source "$Url" -Destination "$env:ProgramData\InstSys\Msys2\$Archive"
}

try { 7z | Out-Null } catch {}
<# Execute only if 7zip is available. #>
if($?){
    Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"$env:TEMP\Msys2Inst`"","`"$env:ProgramData\InstSys\Msys2\$Archive`"" -Wait -NoNewWindow
    Get-ChildItem -Path "$env:TEMP\Msys2Inst" | ForEach-Object {
		$MsysSubArchive = $_.FullName;
        Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"$env:TEMP\Msys2Inst`"","`"$MsysSubArchive`"" -Wait -NoNewWindow
        Remove-Item -Force -Path "$MsysSubArchive"
    }
    Get-ChildItem -Path "$env:TEMP\Msys2Inst" | ForEach-Object {
		$ExtractedDir = $_.FullName;
        Move-Item -Path "$ExtractedDir" -Destination "$env:LOCALAPPDATA\Programs\Msys2"
    }
} else {
    Write-Host -Object "Can not extract Msys2 because 7z.exe is not in the PATH variable."
}