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

$name = Read-Host -Prompt 'Please provide URL to eclipse zip file'

# Set to default URL if no URL is specified by user.
if ([string]::IsNullOrWhiteSpace($name)) {
    $name = 'http://mirrors.uniri.hr/eclipse/eclipse/downloads/drops4/R-4.13-201909161045/eclipse-platform-4.13-win32-x86_64.zip'
}

$pa = "$env:ProgramData\InstSys\eclipse"

# Clean up first
if ( -not (Test-Path "$pa")) { New-Item -Path "$pa" -ItemType Directory }
if (Test-Path "$pa\Eclipse") { Remove-Item -Recurse "$pa\Eclipse" }
if (Test-Path "$pa\Eclipse.zip") { Remove-Item -Recurse "$pa\Eclipse.zip" }
if (Test-Path "$pa\Eclipse.tmp") { Remove-Item -Recurse "$pa\Eclipse.tmp" }
if (Test-Path "$pa\WorkSpace") { Remove-Item -Recurse "$pa\WorkSpace" }

# Download Eclipse
Start-BitsTransfer -Source $name -Destination "$pa\Eclipse.zip"
Expand-Archive -Path "$pa\Eclipse.zip" -Destination "$pa\Eclipse.tmp"
Move-Item "$pa\Eclipse.tmp\eclipse" "$pa\Eclipse"
Remove-Item "$pa\Eclipse.zip"
Remove-Item "$pa\Eclipse.tmp" -Recurse

$FeatureList = @(
	"org.eclipse.epp.mpc.feature.group",
	"org.springframework.tooling.bosh.ls.feature.feature.group",
	"org.springframework.tooling.cloudfoundry.manifest.ls.feature.feature.group",
	"org.springframework.tooling.concourse.ls.feature.feature.group",
	"org.springframework.tooling.boot.ls.feature.feature.group",
	"org.springframework.ide.eclipse.boot.dash.feature.feature.group",
	"org.springframework.boot.ide.main.feature.feature.group",
	"org.springframework.ide.eclipse.xml.namespaces.feature.feature.group",
	"org.eclipse.buildship.feature.group",
	"org.nodeclipse.enide.editors.gradle.feature.feature.group",
	"org.eclipse.m2e.wtp.feature.feature.group",
	"com.jaspersoft.studio.feature.feature.group",
	"org.eclipse.wst.xsl.feature.feature.group",
	"org.eclipse.wst.xml_ui.feature.feature.group",
	"org.eclipse.wst.web_ui.feature.feature.group",
	"org.eclipse.wst.jsdt.feature.feature.group",
	"org.eclipse.wst.server_adapters.feature.feature.group",
	"org.eclipse.jst.ws.jaxws.dom.feature.feature.group",
	"org.eclipse.jst.ws.jaxws.feature.feature.group",
	"org.eclipse.jst.server_adapters.feature.feature.group",
	"org.eclipse.jst.server_adapters.ext.feature.feature.group",
	"org.eclipse.jst.server_ui.feature.feature.group",
	"org.eclipse.jst.web_ui.feature.feature.group",
	"org.eclipse.jst.enterprise_ui.feature.feature.group",
	"org.eclipse.egit.feature.group",
	"org.eclipse.cvs.feature.group",
	"org.tigris.subversion.subclipse.feature.group",
	"org.tigris.subversion.subclipse.mylyn.feature.feature.group",
	"org.tigris.subversion.clientadapter.javahl.feature.feature.group",
	"org.tigris.subversion.subclipse.graph.feature.feature.group",
	"org.tigris.subversion.clientadapter.svnkit.feature.feature.group",
	"org.sonarlint.eclipse.feature.feature.group"
)

$Repos = @(
	"http://download.eclipse.org/releases/2019-09",
	"http://download.eclipse.org/eclipse/updates/4.13",
	"https://download.springsource.com/release/TOOLS/sts4/update/e4.13/",
	"https://download.springsource.com/release/TOOLS/sts4-language-servers/e4.8",
	"http://download.eclipse.org/buildship/updates/e411/releases/3.x",
	"https://download.eclipse.org/egit/updates",
	"http://jasperstudio.sourceforge.net/updates/",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20190827152740/repository/",
	"https://nodeclipse.github.io/updates/",
	"https://dl.bintray.com/subclipse/releases/subclipse/latest/",
	"https://eclipse-uc.sonarlint.org"
)

$ReposString = Convert-ArrayToString -StringArray $Repos

# Start and wait for user to finish modifications
New-Item -ItemType Directory -Path "$pa\WorkSpace"
$i = 1
$Plc = $FeatureList.Count

foreach($Feature in $FeatureList){
	
	Write-Host -Object "Installing plugin ${i} of ${Plc}: ${Feature}"

	Start-Process `
		-FilePath "$pa\Eclipse\eclipse.exe" `
		-Wait `
		-ArgumentList `
			"-application","org.eclipse.equinox.p2.director",`
			"-repository","$ReposString",`
			"-installIU","$Feature"
	$i++;
}


# 
# Configure Workspace
$path = "$pa\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

If (-Not (Test-Path -Path "$path")) {
	New-Item -ItemType Directory -Path "$path"
}

$file = "org.eclipse.e4.ui.workbench.renderers.swt.prefs"
Set-Content -Path "$path\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$path\$file" -Value "enableMRU=true"
Add-Content -Path "$path\$file" -Value "themeEnabled=false"

$file = "org.eclipse.core.runtime.prefs"
Set-Content -Path "$path\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$path\$file" -Value "line.separator=`\n"

$file = "org.eclipse.core.resources.prefs"
Set-Content -Path "$path\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$path\$file" -Value "encoding=UTF-8"
Add-Content -Path "$path\$file" -Value "version=1"

$file = "org.eclipse.ui.ide.prefs"
Set-Content -Path "$path\$file" -Value "EXIT_PROMPT_ON_CLOSE_LAST_WINDOW=false"

# Start eclipse for further customization
Start-Process -FilePath "$pa\Eclipse\eclipse.exe" -ArgumentList "-data","$pa\WorkSpace" -Wait