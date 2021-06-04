param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Java"
)

$urls = @(
	"https://cdn.azul.com/zulu/bin/zulu16.30.15-ca-fx-jdk16.0.1-win_x64.zip",
	"https://cdn.azul.com/zulu/bin/zulu15.32.15-ca-fx-jdk15.0.3-win_x64.zip",
	"https://cdn.azul.com/zulu/bin/zulu11.48.21-ca-fx-jdk11.0.11-win_x64.zip",
	"https://cdn.azul.com/zulu/bin/zulu8.54.0.21-ca-fx-jdk8.0.292-win_x64.zip"
)

$DownloadDir = "$env:ProgramData\InstSys\java"

$default = "jdk16"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$env:TEMP\JavaInst"){
	Remove-Item -Recurse -Force -Path "$env:TEMP\JavaInst"
}
New-Item -ItemType "Directory" -Path "$env:TEMP\JavaInst"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

foreach($url in $urls){
	$Array = ($url -split "/")
	$fname=  $Array[$Array.Length - 1]
	$ProgressPreference = 'SilentlyContinue'
	if(-not (Test-Path -Path "$DownloadDir\$fname")){
		Invoke-WebRequest -Uri "$url" -OutFile "$DownloadDir\$fname"
	}
	try { 7z | Out-Null } catch {}
	if(-not ($?)){
		Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
	} else {
		Start-Process -FilePath "7z.exe" -ArgumentList "x","-aos","-o`"$env:TEMP\JavaInst`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$DownloadDir\$fname`"" -Wait -NoNewWindow
	}
}
try { 7z | Out-Null } catch {}
<# Execute only if 7zip is available. #>
if($?){
	Get-ChildItem -Path "$env:TEMP\JavaInst" | ForEach-Object {
		Move-Item -Path $_.FullName -Destination "$InstallDir"
		if($_.Name -like "*$default*"){
			Write-Host -Object "Setting default to $($_.Name)"
			$CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", "USER")
			<# Add a trailing semicolon if it is missing at the end. #>
			if ($CurrentPath -notmatch ';$') { $CurrentPath += ';' }
			[System.Environment]::SetEnvironmentVariable("PATH", $CurrentPath + "$InstallDir\$($_.Name)\bin;", [System.EnvironmentVariableTarget]::User)
		}
	}
}