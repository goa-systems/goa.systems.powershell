$urls = @(
	"https://cdn.azul.com/zulu/bin/zulu13.29.9-ca-jdk13.0.2-win_x64.zip",
	"https://cdn.azul.com/zulu/bin/zulu11.37.17-ca-jdk11.0.6-win_x64.zip",
	"https://cdn.azul.com/zulu/bin/zulu8.44.0.11-ca-jdk8.0.242-win_x64.zip"
)

$DownloadDir = "$env:ProgramData\InstSys\java"

$default = "jdk13"

if(-not (Test-Path -Path "$env:LOCALAPPDATA\Programs\Java")){
	New-Item -ItemType "Directory" -Path "$env:LOCALAPPDATA\Programs\Java"
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
if($?){
	Get-ChildItem -Path "$env:TEMP\JavaInst" | ForEach-Object {
		Move-Item -Path $_.FullName -Destination "$env:LOCALAPPDATA\Programs\Java"
		if($_.Name -like "*$default*"){
			Write-Host -Object "Setting default to $($_.Name)"
			[System.Environment]::SetEnvironmentVariable("PATH", [System.Environment]::GetEnvironmentVariable("PATH", "USER") + "$env:LOCALAPPDATA\Programs\Java\$($_.Name)\bin;", [System.EnvironmentVariableTarget]::User)
		}
	}
}