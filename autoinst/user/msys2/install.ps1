
function Install-Msys2 {
    
    [CmdletBinding()]
    param (

        [Parameter()]
        [string]
        $Url,

        [Parameter()]
        [string]
        $Name
    )

    $DownloadDir = "${env:TEMP}\$(New-Guid)"
    if(Test-Path -Path "${DownloadDir}"){
        Remove-Item -Force -Recurse -Path "${DownloadDir}"
    }
    New-Item -Path "${DownloadDir}" -ItemType "Directory"

    Start-BitsTransfer -Source "${Url}" -Destination "${DownloadDir}\$Archive"

    if(Test-Path -Path "${env:ProgramFiles}\7-Zip"){
        $env:Path = "${env:ProgramFiles}\7-Zip;${env:PATH}"
    }

    try { 7z | Out-Null } catch {}
    <# Execute only if 7zip is available. #>
    if($?){
        Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"$env:TEMP\Msys2Inst`"","`"$env:ProgramData\InstSys\Msys2\$Name`"" -Wait -NoNewWindow
        Get-ChildItem -Path "$env:TEMP\Msys2Inst" | ForEach-Object {
            $MsysSubArchive = $_.FullName;
            Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"$env:TEMP\Msys2Inst`"","`"$MsysSubArchive`"" -Wait -NoNewWindow
            Remove-Item -Force -Path "$MsysSubArchive"
        }
        Get-ChildItem -Path "$env:TEMP\Msys2Inst" | ForEach-Object {
            $ExtractedDir = $_.FullName;
            Move-Item -Path "$ExtractedDir" -Destination "$env:LOCALAPPDATA\Programs\Msys2"
        }

        <# Run the initial setup. Msys2 has to be exited afterwards and restarted. #>
        Start-Process -FilePath "$env:LOCALAPPDATA\Programs\Msys2\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"exit`"") -Wait

        <# Run update three times because some updates need a restart. #>
        for ($i = 0; $i -lt 3; $i++) {
            Start-Process -FilePath "$env:LOCALAPPDATA\Programs\Msys2\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"pacman -Syu --noconfirm; exit;`"") -Wait
        }
        <# Install the tools #>
        Start-Process -FilePath "$env:LOCALAPPDATA\Programs\Msys2\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"pacman -S --noconfirm base binutils gcc gdb git make mingw-w64-i686-make mingw-w64-x86_64-binutils mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-make openssh vim; exit;`"") -Wait

    } else {
        Write-Host -Object "Can not extract Msys2 because 7z.exe is not in the PATH variable."
    }
    
}

$Release = Invoke-RestMethod -Uri "https://api.github.com/repos/msys2/msys2-installer/releases/latest"
$DownloadUrl = ""
$FileName = ""
$Release.assets | ForEach-Object {
    $Asset = $($_)
    if($Asset.name -match ".*\.tar\.xz$"){
        $FileName += $Asset.name
        $DownloadUrl += "$($Asset.browser_download_url)"
    }
}

if($DownloadUrl -ne ""){
    Write-Host -Object "Download URL is $DownloadUrl. Downloading and installing Msys2."
    Install-Msys2 -Url $DownloadUrl -Name $FileName
    Write-Host -Object "Download and setup done."
}