param (
	# The features to install. Default: Marketplace client.
	[String[]] $FeatureList = @("org.eclipse.epp.mpc.feature.group"),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $Repos = @("http://download.eclipse.org/releases/2020-06", "http://download.eclipse.org/eclipse/updates/4.16"),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $AdditionalPlugins = @(),

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "$env:ProgramData\InstSys\eclipse",

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $EclipseUrl = "http://mirror.dkm.cz/eclipse/eclipse/downloads/drops4/R-4.16-202006040540/eclipse-platform-4.16-win32-x86_64.zip",

	# Start eclipse to modify the working directory?
	[Boolean] $ModifyWorkspace = $true
)

function Convert-ArrayToString {
	param (
		# Array of strings
		[Parameter(Mandatory=$true)]
		[String[]]
		$StringArray
	)
	$String = ""
	for ($i = 0; $i -lt $StringArray.Count - 1; $i++) {
		$Element = $StringArray[$i]
		$String += "$Element,"
	}
	$String += $StringArray[$i]
	return $String
}

# Clean up first
if ( -not (Test-Path "$WorkingDirectory")) { New-Item -Path "$WorkingDirectory" -ItemType Directory }
if (Test-Path "$WorkingDirectory\Eclipse") { Remove-Item -Recurse "$WorkingDirectory\Eclipse" }
if (Test-Path "$WorkingDirectory\Eclipse.zip") { Remove-Item -Recurse "$WorkingDirectory\Eclipse.zip" }
if (Test-Path "$WorkingDirectory\Eclipse.tmp") { Remove-Item -Recurse "$WorkingDirectory\Eclipse.tmp" }
if (Test-Path "$WorkingDirectory\WorkSpace") { Remove-Item -Recurse "$WorkingDirectory\WorkSpace" }

# Download Eclipse
Start-BitsTransfer -Source "$EclipseUrl" -Destination "$WorkingDirectory\Eclipse.zip"
Expand-Archive -Path "$WorkingDirectory\Eclipse.zip" -Destination "$WorkingDirectory\Eclipse.tmp"
Move-Item "$WorkingDirectory\Eclipse.tmp\eclipse" "$WorkingDirectory\Eclipse"
Remove-Item "$WorkingDirectory\Eclipse.zip"
Remove-Item "$WorkingDirectory\Eclipse.tmp" -Recurse

$PluginInstallSuccess = $true

foreach($Plugin in $AdditionalPlugins){
	try {
		# Invoke-WebRequest -Uri "$Plugin" -OutFile "$WorkingDirectory\Eclipse\plugins"
		Start-BitsTransfer -Source "$Plugin" -Destination "$WorkingDirectory\Eclipse\plugins" -ErrorAction Stop
		Start-Sleep -Seconds 2
	} catch {
		Write-Error -Message "There has been a download error with the url ${Plugin}."
		<# If one error is thrown, the plugins are not installed correctly. #>
		$PluginInstallSuccess = $PluginInstallSuccess -and $false
	}
}

if($PluginInstallSuccess){

	$ReposString = Convert-ArrayToString -StringArray $Repos

	# Start and wait for user to finish modifications
	# New-Item -ItemType Directory -Path "$WorkingDirectory\WorkSpace"
	$i = 1
	$Plc = $FeatureList.Count

	foreach($Feature in $FeatureList){
		
		Write-Host -Object "Installing plugin ${i} of ${Plc}: ${Feature}"

		Start-Process `
			-FilePath "$WorkingDirectory\Eclipse\eclipse.exe" `
			-Wait `
			-ArgumentList `
				"-application","org.eclipse.equinox.p2.director",`
				"-repository","$ReposString",`
				"-installIU","$Feature"
		$i++;
	}


	# 
	# Configure Workspace
	$SettingsPath = "$WorkingDirectory\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

	If (-Not (Test-Path -Path "$SettingsPath")) {
		New-Item -ItemType Directory -Path "$SettingsPath"
	}

	$configfiles = @(
		"org.eclipse.core.resources.prefs",
		"org.eclipse.core.runtime.prefs",
		"org.eclipse.e4.ui.workbench.renderers.swt.prefs",
		"org.eclipse.ui.editors.prefs",
		"org.eclipse.ui.ide.prefs",
		"org.eclipse.ui.prefs"
	)

	foreach($file in $configfiles){
		Copy-Item -Path "conf\$file" -Destination "$SettingsPath\$file"
	}

	# Start eclipse for further customization
	if($ModifyWorkspace){
		Start-Process -FilePath "$WorkingDirectory\Eclipse\eclipse.exe" -ArgumentList "-data","$WorkingDirectory\WorkSpace" -Wait
	}
} else {
	Write-Host -Object "Additional plugins were net installed successfully. Eclipse not configured."
}