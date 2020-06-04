param (
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\Gradle"
)

$FileName = "gradle-6.5-bin.zip"
$Url = "https://services.gradle.org/distributions/$FileName"

$DownloadDir = "$env:ProgramData\InstSys\gradle"

if(-not (Test-Path -Path "$InstallDir")){
	New-Item -ItemType "Directory" -Path "$InstallDir"
}
if(Test-Path -Path "$env:TEMP\GradleInst"){
	Remove-Item -Recurse -Force -Path "$env:TEMP\GradleInst"
}
New-Item -ItemType "Directory" -Path "$env:TEMP\GradleInst"

if(-not (Test-Path -Path "$DownloadDir")){
	New-Item -ItemType "Directory" -Path "$DownloadDir"
}

$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\$FileName"

try { 7z | Out-Null } catch {}
if(-not ($?)){
	Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
} else {
	Start-Process -FilePath "7z.exe" -ArgumentList "x","-aos","-o`"$env:TEMP\GradleInst`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$DownloadDir\$FileName`"" -Wait -NoNewWindow
}

<# Move extracted folder to the program installation directory. #>
Get-ChildItem -Path "$env:TEMP\GradleInst" | ForEach-Object {
	
	$TmpName = $_.Name
	Move-Item -Path $_.FullName -Destination "$InstallDir"
	
	<# Update path variable #>
	$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
	$NewPath = ""
	$Found = $False
	foreach($pathvar in $pathvars){

		<# If Gradle is already set in path variable. update the variable. #>
		if(-not [string]::IsNullOrEmpty($pathvar)){
			if($pathvar -like "*Gradle*"){
				$NewPath += "$InstallDir\$TmpName\bin;"
				$Found = $True
			} else {
				$NewPath += "$pathvar;"
			}
		}
	}
	if( -not $Found){
		$NewPath += "$InstallDir\$TmpName\bin"
	}
	[System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::User)
}
