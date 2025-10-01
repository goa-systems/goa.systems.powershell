$GitHubUrl = "https://api.github.com/repos/obsproject/obs-studio/releases/latest"
(Invoke-RestMethod -Uri "${GitHubUrl}").Assets | ForEach-Object {
	$BrowserDownloadUrl = $_.browser_download_url
	if ("${BrowserDownloadUrl}" -match "(.*)-Windows-x64.zip") {
		$TempDir = "${env:TEMP}\$(New-Guid)"
		$AppDir = "${env:LOCALAPPDATA}\Programs\OBS Studio"
		if (Test-Path -Path "${TempDir}") {
			Remove-Item -Recurse -Force -Path "${TempDir}"
		}
		New-Item -ItemType "Directory" -Path "${TempDir}"
		Start-BitsTransfer -Source "${BrowserDownloadUrl}" -Destination "${TempDir}"
		$ZipFile = ""
		Get-ChildItem -Path "${TempDir}" | ForEach-Object {
			$ZipFile += $_.FullName
		}
		if (Test-Path -Path "${AppDir}") {
			Remove-Item -Recurse -Force -Path "${AppDir}"
		}
		New-Item -ItemType "Directory" -Path "${AppDir}"
		Expand-Archive -Path "${ZipFile}" -DestinationPath "${AppDir}"
		Remove-Item -Recurse -Force -Path "${TempDir}"

		[System.Environment]::SetEnvironmentVariable("OBS_HOME", "${AppDir}", [System.EnvironmentVariableTarget]::User)
		$env:OBS_HOME = "${AppDir}"

		if (Test-Path -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\OBS Studio.lnk") {
			Remove-Item -Force -Path "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\OBS Studio.lnk"
		}
		$Shell = New-Object -ComObject ("WScript.Shell")
		$ShortCut = $Shell.CreateShortcut("${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\OBS Studio.lnk")
		$ShortCut.TargetPath = "%OBS_HOME%\bin\64bit\obs64.exe"
		$ShortCut.Arguments = ""
		$ShortCut.WorkingDirectory = "%OBS_HOME%\bin\64bit";
		$ShortCut.WindowStyle = 1;
		$ShortCut.Hotkey = "";
		$ShortCut.IconLocation = "%OBS_HOME%\bin\64bit\obs64.exe, 0";
		$ShortCut.Description = "OBS Studio";
		$ShortCut.Save()
	}
}