param (
	# The features to install. Default: Marketplace client.
	[String[]] $FeatureList = @(
		"com.jaspersoft.studio.feature.feature.group"
		),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $Repos = @(
		"http://download.eclipse.org/releases/2020-06",
		"http://download.eclipse.org/eclipse/updates/4.16",
		"http://jasperstudio.sourceforge.net/updates"
		),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $AdditionalPlugins = @(
		"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.pool_1.6.0.v201204271246.jar",
		"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.dbcp_1.4.0.v201204271417.jar",
		"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.transaction_1.1.1.v201105210645.jar",
		"https://download.eclipse.org/releases/2019-09/201909181001/plugins/org.eclipse.wb.swt_1.9.1.201812270937.jar",
		"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.xml.bind_2.2.0.v201105210648.jar",
		"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.activation_1.1.0.v201211130549.jar"
	),

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "$env:ProgramData\InstSys\eclipse",

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $EclipseUrl = "http://mirror.dkm.cz/eclipse/eclipse/downloads/drops4/R-4.16-202006040540/eclipse-platform-4.16-win32-x86_64.zip",

	# Start eclipse to modify the working directory?
	[Boolean] $ModifyWorkspace = $False
)

function Convert-ArrayToString {
	param (
		# Array of strings
		[Parameter(Mandatory=$True)]
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

$ConfigWorkspace = $True

# If working directories already exist Eclipse will not be downloaded again.
if ((Test-Path "$WorkingDirectory") -and (Test-Path "$WorkingDirectory\Eclipse") -and (Test-Path "$WorkingDirectory\WorkSpace")) {
	Write-Host -Object "Working directories already exist. If a new install is required, please delete the folder `"$WorkingDirectory`""
	$ConfigWorkspace = $False
} else {
	if ((Test-Path "$WorkingDirectory") -or (Test-Path "$WorkingDirectory\Eclipse") -or (Test-Path "$WorkingDirectory\WorkSpace")){ Remove-Item -Path "$WorkingDirectory" -Force -Recurse }
	New-Item -ItemType "Directory" -Path "$WorkingDirectory"
	New-Item -ItemType "Directory" -Path "$WorkingDirectory\WorkSpace"
	
	# Download Eclipse
	Start-BitsTransfer -Source "$EclipseUrl" -Destination "$WorkingDirectory\Eclipse.zip"
	Expand-Archive -Path "$WorkingDirectory\Eclipse.zip" -Destination "$WorkingDirectory\Eclipse.tmp"
	Move-Item "$WorkingDirectory\Eclipse.tmp\eclipse" "$WorkingDirectory\Eclipse"
	Remove-Item "$WorkingDirectory\Eclipse.zip"
	Remove-Item "$WorkingDirectory\Eclipse.tmp" -Recurse
}

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

	if($ConfigWorkspace){

		# Configure Workspace and automatic updates
		$SettingsPath = "$WorkingDirectory\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"
		$UpdateConfPath = "$WorkingDirectory\Eclipse\p2\org.eclipse.equinox.p2.engine\profileRegistry\SDKProfile.profile\.data\.settings"

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
			Copy-Item -Path "conf\org.eclipse.equinox.p2.ui.sdk.scheduler.prefs" -Destination "$SettingsPath\$file"
		}

		# Enable automatic updates
		Copy-Item -Path "conf\org.eclipse.equinox.p2.ui.sdk.scheduler.prefs" -Destination "$UpdateConfPath\org.eclipse.equinox.p2.ui.sdk.scheduler.prefs"
	}

	# Start eclipse for further customization
	if($ModifyWorkspace){
		Start-Process -FilePath "$WorkingDirectory\Eclipse\eclipse.exe" -ArgumentList "-data","$WorkingDirectory\WorkSpace" -Wait
	}
} else {
	Write-Host -Object "Additional plugins were net installed successfully. Eclipse not configured."
}