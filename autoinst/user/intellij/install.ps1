param (
	
	[String]
	$InstallDir = "$env:LOCALAPPDATA\Programs\IntelliJ",
	
	[String]
	$Version = "2020.2.1"
)

$FileName = "ideaIC-$Version.win.zip"
$Url = "https://download-cf.jetbrains.com/idea/$FileName"

if(Test-Path -Path "$InstallDir\$Version"){
	
	Write-Host -Object "Defined version already installed."

} else {

	$DownloadDir = "$env:ProgramData\InstSys\intellij"

	if(-not (Test-Path -Path "$InstallDir")){
		New-Item -ItemType "Directory" -Path "$InstallDir"
	}
	
	if(Test-Path -Path "$env:TEMP\IntelliJInst"){
		Remove-Item -Recurse -Force -Path "$env:TEMP\IntelliJInst"
	}
	New-Item -ItemType "Directory" -Path "$env:TEMP\IntelliJInst\$Version"
	
	if(-not (Test-Path -Path "$DownloadDir")){
		New-Item -ItemType "Directory" -Path "$DownloadDir"
	}
	
	if( -Not (Test-Path -Path "$DownloadDir\$FileName" )){
		$ProgressPreference = 'SilentlyContinue'
		Invoke-WebRequest -Uri "$Url" -OutFile "$DownloadDir\$FileName"
	}
	
	try { 7z | Out-Null } catch {}
	if(-not ($?)){
		Write-Host -Object "Can not find 7z.exe. Please check your global path and rerun installer."
	} else {
		Start-Process -FilePath "7z" -ArgumentList "x","-aos","-o`"$env:TEMP\IntelliJInst\$Version`"","-bb0","-bse0","-bsp2","-pdefault","-sccUTF-8","`"$DownloadDir\$FileName`"" -Wait -NoNewWindow
	}
	
	<# Move extracted folder to the program installation directory. #>
	Get-ChildItem -Path "$env:TEMP\IntelliJInst" | ForEach-Object {
		
		$TmpName = $_.Name
		Move-Item -Path $_.FullName -Destination "$InstallDir"
	
		..\..\insttools\CreateShortcut.ps1 `
			-LinkName "IntelliJ IDEA" `
			-TargetPath "$InstallDir\$Version\bin\idea64.exe" `
			-Arguments "" `
			-IconFile "$InstallDir\$Version\bin\idea64.exe" `
			-IconId 0 `
			-Description "IntelliJ IDEA" `
			-WorkingDirectory "%UserProfile%" `
			-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")
		
		<# Update path variable #>
		$pathvars = ([System.Environment]::GetEnvironmentVariable("PATH","USER")) -split ";"
		$NewPath = ""
		$Found = $False
		foreach($pathvar in $pathvars){
	
			<# If IntelliJ is already set in path variable. update the variable. #>
			if(-not [string]::IsNullOrEmpty($pathvar)){
				if($pathvar -like "*IntelliJ*"){
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
}

