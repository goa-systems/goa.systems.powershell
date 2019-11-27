param (
	# The certificate file.
	[String] $CaCert = "rootca.crt.pem",

	# The directory containing the JDK installations.
	[String] $JavaInstDirectory = "$env:USERPROFILE\Downloads\OpenJDK",

	# The name to give to the certificate entry.
	[String] $CertName = "DefaultName"
)

Get-ChildItem -Path $JavaInstDirectory | ForEach-Object {
	$fullpath = $_.FullName
	$legacy = $false
	if (Test-Path "$fullpath\jre") {
		$fullpath = "$fullpath\jre"
		$legacy = $true
	}
	$keytool = "$fullpath\bin\keytool.exe"
	$cacerts = "$fullpath\lib\security\cacerts"
	if($CertName -eq "DefaultName"){
		$CertName = [io.path]::GetFileNameWithoutExtension($CaCert)
	}
	if($legacy){
		Start-Process -FilePath "$keytool" -ArgumentList "-importcert", "-noprompt", "-keystore", "`"$cacerts`"", "-storepass", "changeit", "-alias", "`"$CertName`"", "-file", "`"$CaCert`"" -Wait -NoNewWindow
	} else {
		Start-Process -FilePath "$keytool" -ArgumentList "-importcert", "-noprompt", "-storepass", "changeit", "-alias", "`"$CertName`"", "-file", "`"$CaCert`"", "-cacerts" -Wait -NoNewWindow
	}
}