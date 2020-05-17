if( -not (Test-Path -Path "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu")){
	Copy-Item -Path "$PSScriptRoot\registrymodifications.xcu" -Destination "$env:APPDATA\LibreOffice\4\user\registrymodifications.xcu"
} else {
	Write-Error -Message "Configuration file already exists."
}