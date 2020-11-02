param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\NodeJS"
)

$Version = "14.15.0"
$FileName = "node-v$Version-win-x64.zip"
$DownloadUrl = "https://nodejs.org/dist/v$Version/$FileName"
$AppName = "nodejs"

$DownloadDir = "$env:ProgramData\InstSys\$AppName"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$env:TEMP\$AppName"){
	Remove-Item -Recurse -Force -Path "$env:TEMP\$AppName"
}
New-Item -ItemType "Directory" -Path "$env:TEMP\$AppName"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$DownloadUrl" -OutFile "$DownloadDir\$FileName"

try { 7z | Out-Null } catch {}
if(-not ($?)){
	Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
} else {
	Start-Process -FilePath "7z.exe" -ArgumentList "x","-aos","-o`"$env:TEMP\$AppName`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$DownloadDir\$FileName`"" -Wait -NoNewWindow
}

Get-ChildItem -Path "$env:TEMP\$AppName" | ForEach-Object {
	
	$TmpName = $_.Name
	Move-Item -Path $_.FullName -Destination "$InstallDir"
	
	$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
	$NewPath = ""
	$Found = $False
	foreach($pathvar in $pathvars){

		if(-not [string]::IsNullOrEmpty($pathvar)){
			if($pathvar -like "*Node.js*"){
				$NewPath += "$InstallDir\$TmpName;"
				$Found = $True
			} else {
				$NewPath += "$pathvar;"
			}
		}
	}
	if( -not $Found){
		$NewPath += "$InstallDir\$TmpName"
	}
	[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)
}