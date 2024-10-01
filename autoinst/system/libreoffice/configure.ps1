param (
	# Force overwriting of existing configuration file.
	[switch]
	$Force,

	# Change the skeleton file in the template directory for new users.
	[switch]
	$System
)

# Check where to install the configuration file.
if($System){
	$Path = "$env:SystemDrive\Users\Default\AppData\Roaming\LibreOffice\4\user"
} else {
	$Path = "$env:APPDATA\LibreOffice\4\user"
}

#If directory does not exist, create it.
if( -not (Test-Path -Path "$Path")){
	if($System){
		if((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
			New-Item -Path "$Path" -ItemType "Directory"
		}
	} else {
		New-Item -Path "$Path" -ItemType "Directory"
	}
}

if(Test-Path -Path "$Path\registrymodifications.xcu"){
	if($Force){
		if($System -and ( -not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))){
			Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-System","-Force" -Wait -Verb RunAs
		} else {
			Copy-Item -Path "$PSScriptRoot\registrymodifications.xcu" -Destination "$Path"
		}
	} else {
		Write-Error -Message "File already exists. Add the -Force parameter to overwrite."
	}
} else {
	if($System -and ( -not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))){
		Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)","-System" -Wait -Verb RunAs
	} else {
		Copy-Item -Path "$PSScriptRoot\registrymodifications.xcu" -Destination "$Path"
	}
}
