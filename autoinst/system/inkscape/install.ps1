if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$TempDir = "${env:TEMP}\$(New-Guid)"
	$SetupFile = "inkscape-$($Json.version)_$($Json.date)_$($Json.hash)-x64.msi"
	$DownloadUrl = "https://media.inkscape.org/dl/resources/file/$SetupFile"
	If(Test-Path -Path "${TempDir}"){
		Remove-Item -Recurse -Force -Path "${TempDir}"
	}
	New-Item -Path "${TempDir}" -ItemType "Directory"
	<# Download if setup is not found in execution path. #>
	Write-Host "Downloading from ${DownloadUrl}"
	Start-BitsTransfer -Source "${DownloadUrl}" -Destination "${TempDir}\$SetupFile"
	Start-Process -Wait -FilePath "msiexec" -ArgumentList @("/qb","/i","${TempDir}\${SetupFile}","INSTALLLOCATION=`"$env:ProgramFiles\Inkscape`"")
} else {
	$curscriptname = $MyInvocation.MyCommand.Name 
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$curscriptname" -Verb RunAs
}