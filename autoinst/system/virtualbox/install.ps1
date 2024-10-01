if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
	$Json = Get-Content -Raw -Path "version.json" | ConvertFrom-Json
	$vboxvers = $Json.version
	$vboxversrev = "$vboxvers-$($Json.revision)"
	$vboxsetup = "VirtualBox-$vboxversrev-Win.exe"
	$vboxexpacksetup = "Oracle_VM_VirtualBox_Extension_Pack-$vboxvers.vbox-extpack"

	If (-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\virtualbox")) {
		New-Item -Path "$env:SystemDrive\ProgramData\InstSys\virtualbox" -ItemType "Directory"
	}
	
	<# Download virtualbox, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxsetup")) {
		Start-BitsTransfer `
			-Source "https://download.virtualbox.org/virtualbox/$vboxvers/$vboxsetup" `
			-Destination "$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxsetup"
	}
	
	<# Download virtualbox extpack, if setup is not found in execution path. #>
	if ( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxexpacksetup")) {
		Start-BitsTransfer `
			-Source "https://download.virtualbox.org/virtualbox/$vboxvers/$vboxexpacksetup" `
			-Destination "$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxexpacksetup"
	}
	
	Start-Process -FilePath "$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxsetup" -ArgumentList "--extract", "--path", "`"$env:TEMP\VBox`"", "--silent" -Wait
	
	Get-ChildItem -Path "$env:TEMP\VBox" | ForEach-Object {
		if($_.FullName.EndsWith("msi")){
			$msipath = $_.FullName;
			[System.IO.File]::WriteAllBytes("$env:TEMP\VBox\certificate.cer", ((Get-AuthenticodeSignature "$msipath").SignerCertificate).Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert));
			Import-Certificate -FilePath "$env:TEMP\VBox\certificate.cer" -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher"
			Start-Process -FilePath "msiexec.exe" -ArgumentList "/package","$msipath","/passive","/norestart","ADDLOCAL=VBoxApplication,VBoxUSB,VBoxNetworkFlt,VBoxNetworkAdp","NETWORKTYPE=NDIS6","VBOX_INSTALLDESKTOPSHORTCUT=0","VBOX_REGISTERFILEEXTENSIONS=0" -Wait
		}
	}
	
	Start-Process -FilePath "$env:ProgramFiles\Oracle\VirtualBox\VBoxManage.exe" -ArgumentList "extpack","install","$env:SystemDrive\ProgramData\InstSys\virtualbox\$vboxexpacksetup","--replace","--accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c" -Wait
	Remove-Item -Recurse -Path "$env:TEMP\VBox"
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}