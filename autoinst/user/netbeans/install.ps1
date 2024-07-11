param (
	
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Netbeans"
)

$Json = ConvertFrom-Json -InputObject (Get-Content -Path "$(${PSScriptRoot})\version.json" -Raw)
$Version = $Json.version

$FileName = "netbeans-${Version-bin}.zip"
$Url = "https://downloads.apache.org/netbeans/netbeans/${Version}/${FileName}"

if(Test-Path -Path "${InstallDir}\${Version}"){
	
	Write-Host -Object "Defined version already installed."

} else {

	$DownloadDir = "${env:TEMP}\$(New-Guid)"
	
	if(Test-Path -Path "$DownloadDir"){
		Remove-Item -Recurse -Force -Path "${DownloadDir}"
	}
	New-Item -Path "${DownloadDir}" -ItemType "Directory"
	
	if( -Not (Test-Path -Path "${InstallDir}" )){
		New-Item -Path "${InstallDir}" -ItemType "Directory"
	}
	
	if( -Not (Test-Path -Path "${DownloadDir}\${FileName}" )){
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri "${Url}" -OutFile "${DownloadDir}\${FileName}"
	}
	
	Expand-Archive -Path "${DownloadDir}\${FileName}" -DestinationPath "${DownloadDir}"
	Move-Item -Path "${DownloadDir}\netbeans" -Destination "${InstallDir}\${Version}"

	<# Set version based environment variable. #>
	Set-ItemProperty -Path "HKCU:\Environment" -Name "NETBEANS_HOME_${Version}" -Type ExpandString -Value "${InstallDir}\${Version}"

	<# Point general environment variable to version based variable. #>
	Set-ItemProperty -Path "HKCU:\Environment" -Name "NETBEANS_HOME"            -Type ExpandString -Value "%NETBEANS_HOME_22%"

	<# Remove download directory. #>
	Remove-Item -Recurse -Force -Path "${DownloadDir}"
}

