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

$ApiRequestUrl = "https://api.azul.com/metadata/v1/zulu/packages/?java_version=23&os=windows&arch=x64&archive_type=zip&java_package_type=jdk&javafx_bundled=true&distro_version=23&release_status=ga&availability_types=CA&certifications=tck&latest=true"
$Release = (Invoke-RestMethod -Uri "${ApiRequestUrl}")

$DistVersion = (Convert-VersionArray -VersionArray $Release.distro_version)
$JavaVersion = (Convert-VersionArray -VersionArray $Release.java_version)

$ProgressPreference = "SilentlyContinue"
Write-Host -Object "Download started."
Invoke-WebRequest -Uri "$($Release.download_url)" -OutFile "${env:TEMP}\zulu${DistVersion}-ca-fx-jdk${JavaVersion}-win_x64.zip"
Write-Host -Object "Download finished"
$ProgressPreference = "Continue"