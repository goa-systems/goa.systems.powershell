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

    if(Test-Path -Path "${DownloadDir}"){
        Remove-Item -Recurse -Force -Path "${DownloadDir}"
    }
    New-Item -ItemType Directory -Path "${DownloadDir}"

    $MiKTeXInstaller = "basic-miktex-${Version}-x64.exe"

    Start-BitsTransfer -Source "https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/${MiKTeXInstaller}" -Destination "$DownloadDir\${MiKTeXInstaller}"

    Start-Process -FilePath "${DownloadDir}\${MiKTeXInstaller}" -ArgumentList @("--install", "--unattended", "--user-install=`"${MiKTeXInstallDir}`"") -Wait
    Start-Sleep -Seconds 2
    Start-Process -FilePath "${MiKTeXInstallDir}\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "update") -Wait -NoNewWindow
    Remove-Item -Recurse -Force -Path "${DownloadDir}"
}

function Uninstall-MiKTeX {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $MiKTeXInstallDir = "${env:LocalAppData}\Programs\MiKTeX"
    )

    Remove-Item -Recurse -Force -Path "${MiKTeXInstallDir}"
}

function Install-MiKTeXPackages {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $MiKTeXInstallDir = "${env:LocalAppData}\Programs\MiKTeX"
    )

    $Packages = @("adjustbox", "auxhook", "bigintcalc", "bitset", "bookmark", "caption", "collectbox", "colortbl", "csquotes", "etexcmds", "fancyhdr", "float", "footmisc", "footnotebackref", "geometry", "gettitlestring", "hycolor", "ifoddpage", "infwarerr", "intcalc", "koma-script", "kvdefinekeys", "kvoptions", "kvsetkeys", "latex-graphics-dev", "letltxmacro", "ltxcmds", "ly1", "mdframed", "microtype", "mweights", "needspace", "pagecolor", "pdfescape", "refcount", "rerunfilecheck", "setspace", "sourcecodepro", "sourcesanspro", "titling", "uniquecounter", "upquote", "varwidth", "xurl", "zref", "beautybook", "babel-german", "parskip", "booktabs", "footnotehyper", "stringenc", "fancyvrb")
    foreach ($Package in $Packages) {
        Start-Process -FilePath "${MiKTeXInstallDir}\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "install", "${Package}") -Wait -NoNewWindow
    }
}

function Register-MiKTeX {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $MiKTeXInstallDir = "${env:LocalAppData}\Programs\MiKTeX"
    )

    [System.Environment]::SetEnvironmentVariable("MIKTEX_HOME", "${MiKTeXInstallDir}", [System.EnvironmentVariableTarget]::User)
}

function Unregister-MiKTeX {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $MiKTeXInstallDir = "${env:LocalAppData}\Programs\MiKTeX"
    )

    [System.Environment]::SetEnvironmentVariable("MIKTEX_HOME", [NullString]::Value, [System.EnvironmentVariableTarget]::User)
}