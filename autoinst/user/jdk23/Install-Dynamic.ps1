function Convert-VersionArray {
    param (
        # Version array
        [Parameter(Mandatory=$true)]
        [System.Object[]]
        $VersionArray
    )

    $DistroVersion = ""
    foreach ($Segment in $VersionArray) {
        $DistroVersion = "${DistroVersion}.${Segment}"
    }
    $DistroVersion = $DistroVersion.Substring(1) -replace "\.0$",""
    return $DistroVersion
}

function Get-Package {
    param (
        # The download url
        [Parameter(Mandatory=$true)]
        [string]
        $DownloadUrl,

        # The destination file
        [Parameter(Mandatory=$true)]
        [string]
        $OutFile
    )

    $ProgressPreference = "SilentlyContinue"
    Write-Host -Object "Download started."
    Invoke-WebRequest -Uri "${DownloadUrl}" -OutFile "${OutFile}"
    Write-Host -Object "Download finished"
    $ProgressPreference = "Continue"
}

function New-TemporaryDirectory {
    $TempPath = "${env:TEMP}\$(New-Guid)"
    if (Test-Path -Path "${TempPath}") {
        Remove-Item -Recurse -Force "${TempPath}"
    }
    New-Item -ItemType "Directory" -Path "${TempPath}"
}

function Install-Java {
    param (
        # Java version 23, 21, 17, ...
        [Parameter(Mandatory=$true)]
        [string]
        $JavaMajorVersion
    )

    $ApiRequestUrl = "https://api.azul.com/metadata/v1/zulu/packages/?java_version=${JavaMajorVersion}&os=windows&arch=x64&archive_type=zip&java_package_type=jdk&javafx_bundled=true&distro_version=${JavaMajorVersion}&release_status=ga&availability_types=CA&certifications=tck&latest=true"
    
    # Can return multiple releases. Always take the latest on index 0.
    $Release = (Invoke-RestMethod -Uri "${ApiRequestUrl}")[0]

    $DistVersion = (Convert-VersionArray -VersionArray $Release.distro_version)
    $JavaVersion = (Convert-VersionArray -VersionArray $Release.java_version)

    $DownloadTargetFile = "${env:TEMP}\zulu${DistVersion}-ca-fx-jdk${JavaVersion}-win_x64.zip"
    Get-Package -DownloadUrl "$($Release.download_url)" -OutFile "${DownloadTargetFile}"
    $TemporaryDirectory

    $TemporaryDirectory = (New-TemporaryDirectory).FullName

    Expand-Archive -Path "${DownloadTargetFile}" -DestinationPath "${TemporaryDirectory}"

    Get-ChildItem -Path "${TemporaryDirectory}" | ForEach-Object {
        $DestinationBase = "${env:LOCALAPPDATA}\Programs\Java"
        if(-Not (Test-Path -Path "${DestinationBase}")){
            New-Item -ItemType Directory -Path "${DestinationBase}"
        }
        $Destination = "${DestinationBase}\$($_.Name)"
        Move-Item -Path "$($_.FullName)" -Destination "${Destination}"
        [System.Environment]::SetEnvironmentVariable("JAVA_HOME_${JavaMajorVersion}","${Destination}", [System.EnvironmentVariableTarget]::User)
    }

    Remove-Item -Force -Path "${TemporaryDirectory}" -Recurse
    Remove-Item -Force -Path "${env:TEMP}\zulu${DistVersion}-ca-fx-jdk${JavaVersion}-win_x64.zip"
}

@("21","17","11","8") | ForEach-Object { Install-Java -JavaMajorVersion "$($_)" }