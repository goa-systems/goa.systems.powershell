
function Install-Msys2 {
    
    [CmdletBinding()]
    param (

        [Parameter()]
        [string]
        $DownloadUrl,

        [Parameter()]
        [string]
        $FileName
    )

    $InstallDir = "${env:LOCALAPPDATA}\Programs\Msys2"

    $DownloadDir = "${env:TEMP}\$(New-Guid)"
    if(Test-Path -Path "${DownloadDir}"){
        Remove-Item -Force -Recurse -Path "${DownloadDir}"
    }
    New-Item -Path "${DownloadDir}" -ItemType "Directory"

    Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${DownloadDir}\${FileName}"

    if(Test-Path -Path "${env:ProgramFiles}\7-Zip"){
        $env:Path = "${env:ProgramFiles}\7-Zip;${env:PATH}"
    }

    try { 7z | Out-Null } catch {}
    <# Execute only if 7zip is available. #>
    if($?){
        Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"${DownloadDir}`"","`"${DownloadDir}\${FileName}`"" -Wait -NoNewWindow
        Get-ChildItem -Path "${DownloadDir}" | ForEach-Object {
            if($_.Extension -match "\.tar"){
                Write-Host -Object "Extracting tar archive."
                Start-Process -FilePath "7z.exe" -ArgumentList "x","-o`"${DownloadDir}`"","`"$($_.FullName)`"" -Wait -NoNewWindow
                Remove-Item -Force -Path "$($_.FullName)"
                Remove-Item -Force -Path "${DownloadDir}\${FileName}"
            }
        }

        if( -Not (Test-Path -Path "${InstallDir}")){
            Move-Item -Path "${DownloadDir}\msys64" -Destination "${InstallDir}"

            Start-Process -FilePath "${InstallDir}\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"exit`"") -Wait
            for ($i = 0; $i -lt 3; $i++) {
                Start-Process -FilePath "${InstallDir}\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"pacman -Syu --noconfirm; exit;`"") -Wait
            }
            Start-Process -FilePath "${InstallDir}\msys2_shell.cmd" -ArgumentList @("-mingw64", "-c", "`"pacman -S --noconfirm base binutils gcc gdb git make mingw-w64-i686-make mingw-w64-x86_64-binutils mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-make openssh vim; exit;`"") -Wait

            Remove-Item -Recurse -Force -Path "${DownloadDir}"
            
            $env:MSYS2_HOME = "${InstallDir}"
            [System.Environment]::SetEnvironmentVariable("MSYS2_HOME", "${InstallDir}", [System.EnvironmentVariableTarget]::User) 

        } else {
            Write-Host -Object "Installation directory already exists. Aborting. Downloaded application remains in [${DownloadDir}]."
        }

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
    Install-Msys2 -DownloadUrl $DownloadUrl -FileName $FileName
    Write-Host -Object "Download and setup done."
}