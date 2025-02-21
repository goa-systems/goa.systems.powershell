function Install-MiKTeX {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir = "${env:TEMP}\$(New-Guid)",

        [Parameter()]
        [string]
        $Version = "24.1",

        [Parameter()]
        [string]
        $MiKTeXInstallDir = "${env:LocalAppData}\Programs\MiKTeX"
    )

    if( -Not (Test-Path -Path "${DownloadDir}")){
        New-Item -ItemType Directory -Path "${DownloadDir}"
    }

    $MiKTeXInstaller = "basic-miktex-$Version-x64.exe"

    Start-BitsTransfer -Source "https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/$MiKTeXInstaller" -Destination "$DownloadDir\$MiKTeXInstaller"

    Start-Process -FilePath "$DownloadDir\$MiKTeXInstaller" -ArgumentList @("--install", "--unattended", "--user-install=`"$MiKTeXInstallDir`"") -Wait
    Start-Process -FilePath "$MiKTeXInstallDir\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "update") -Wait -NoNewWindow
    $Packages = @("adjustbox", "auxhook", "bigintcalc", "bitset", "bookmark", "caption", "collectbox", "colortbl", "csquotes", "etexcmds", "fancyhdr", "float", "footmisc", "footnotebackref", "geometry", "gettitlestring", "hycolor", "ifoddpage", "infwarerr", "intcalc", "koma-script", "kvdefinekeys", "kvoptions", "kvsetkeys", "latex-graphics-dev", "letltxmacro", "ltxcmds", "ly1", "mdframed", "microtype", "mweights", "needspace", "pagecolor", "pdfescape", "refcount", "rerunfilecheck", "setspace", "sourcecodepro", "sourcesanspro", "titling", "uniquecounter", "upquote", "varwidth", "xurl", "zref", "beautybook", "babel-german", "parskip", "booktabs", "footnotehyper", "stringenc")
    foreach ($Package in $Packages) {
        Start-Process -FilePath "$MiKTeXInstallDir\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "install", "$Package") -Wait -NoNewWindow
    }
}