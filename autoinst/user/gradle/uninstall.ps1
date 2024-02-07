
try { "gradle --version" | Out-Null } catch {}
if(-not ($?)){
	Write-Host -Object "Gradle not installed."
} else {
	Write-Host -Object "Gradle installed. Trying to stop all deamons."
	Start-Process -FilePath "gradle" -ArgumentList "--stop" -Wait
	Write-Host -Object "Removing folder ..."
	do {
		try {
			Remove-Item -Path "$env:LOCALAPPDATA\Programs\Gradle" -Recurse -Force -ErrorAction Stop
			$ErrorOccured = $False
		} catch {
			$ErrorOccured = $True
			Start-Sleep -Seconds 4
		}
	} while ($ErrorOccured)
	Write-Host -Object "Folder removed."
}

# Remove Gradle from path
[System.Environment]::SetEnvironmentVariable("GRADLE_HOME", $null, [System.EnvironmentVariableTarget]::User)

if(Test-Path -Path "$env:LOCALAPPDATA\Programs\Gradle"){
	Remove-Item -Path "$env:LOCALAPPDATA\Programs\Gradle" -Recurse -Force
}

<# Testing for Gradle creates a directory ".gradle". This is not needed and is removed by the following code. #>
if(Test-Path -Path "$PSScriptRoot\.gradle"){
	Remove-Item -Path "$PSScriptRoot\.gradle" -Recurse -Force
}