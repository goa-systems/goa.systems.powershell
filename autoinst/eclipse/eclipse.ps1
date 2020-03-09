param (
	# The features to install. Default: Marketplace client.
	[String[]] $FeatureList = @("org.eclipse.epp.mpc.feature.group"),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $Repos = @("http://download.eclipse.org/releases/2019-12", "http://download.eclipse.org/eclipse/updates/4.14"),

	# The repositories to download from. Default: Eclipse repos.
	[String[]] $AdditionalPlugins = @(),

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "$env:ProgramData\InstSys\eclipse",

	# The working directory. Default ProgramData\instsys\eclipse
	[String] $EclipseUrl = "http://mirrors.uniri.hr/eclipse/eclipse/downloads/drops4/R-4.14-201912100610/eclipse-platform-4.14-win32-x86_64.zip"
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

foreach($Plugin in $AdditionalPlugins){
	try {
		Start-BitsTransfer -Source "$Plugin" -Destination "$WorkingDirectory\Eclipse\plugins" -ErrorAction Stop
	} catch {
		Write-Error -Message "There has been a download error with the url ${Plugin}."
	}
}

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
$WorkingDirectoryth = "$WorkingDirectory\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

If (-Not (Test-Path -Path "$WorkingDirectoryth")) {
	New-Item -ItemType Directory -Path "$WorkingDirectoryth"
}

# Disable theming and set to classic GUI
$file = "org.eclipse.e4.ui.workbench.renderers.swt.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "enableMRU=true"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "themeEnabled=false"

# Set line separator to linux style
$file = "org.eclipse.core.runtime.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "line.separator=`\n"

# Set workspace encoding to UTF-8
$file = "org.eclipse.core.resources.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "encoding=UTF-8"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "version=1"

# Don't show confirmation dialog on exit
$file = "org.eclipse.ui.ide.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "EXIT_PROMPT_ON_CLOSE_LAST_WINDOW=false"

# Don't show welcome screen on first startup
$file = "org.eclipse.ui.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "USE_COLORED_LABELS=false"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "showIntro=false"

# Show line numbering
$file = "org.eclipse.ui.editors.prefs"
Set-Content -Path "$WorkingDirectoryth\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkingDirectoryth\$file" -Value "lineNumberRuler=true"

# Start eclipse for further customization
Start-Process -FilePath "$WorkingDirectory\Eclipse\eclipse.exe" -ArgumentList "-data","$WorkingDirectory\WorkSpace" -Wait