param (
	
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Netbeans"
)

$Json = ConvertFrom-Json -InputObject (Get-Content -Path "$(${PSScriptRoot})\version.json" -Raw)
$Version = $Json.version

$FileName = "netbeans-$Version-bin.zip"
$Url = "https://downloads.apache.org/netbeans/netbeans/$Version/$FileName"

if(Test-Path -Path "$InstallDir\$Version"){
	
	Write-Host -Object "Defined version already installed."

} else {

	$DownloadDir = "$env:ProgramData\InstSys\netbeans"
	
	if( -Not (Test-Path -Path "$DownloadDir" )){
		New-Item -Path "$DownloadDir" -ItemType "Directory"
	}
	
	if( -Not (Test-Path -Path "$InstallDir" )){
		New-Item -Path "$InstallDir" -ItemType "Directory"
	}
	
	if(Test-Path -Path "$env:TEMP\Netbeans"){
		Remove-Item -Recurse -Force -Path "$env:TEMP\Netbeans"
	}
	New-Item -ItemType "Directory" -Path "$env:TEMP\Netbeans"
	
	if( -Not (Test-Path -Path "$DownloadDir\$FileName" )){
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\$FileName"
	}
	
	try { 7z | Out-Null } catch {}
	if(-not ($?)){
		Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
	} else {
		Start-Process -FilePath "7z" -ArgumentList "x","-aos","-o`"$env:TEMP\Netbeans`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$DownloadDir\$FileName`"" -Wait -NoNewWindow
	}
	
	<# Move extracted folder to the program installation directory. #>
	Get-ChildItem -Path "$env:TEMP\Netbeans" | ForEach-Object {
		
	 	Move-Item -Path $_.FullName -Destination "$InstallDir\$Version"

		 [System.Environment]::SetEnvironmentVariable("NETBEANS_HOME", "$InstallDir\$Version", [System.EnvironmentVariableTarget]::User)
	}
}

