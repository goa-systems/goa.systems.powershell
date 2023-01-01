$WorkDir = "$env:TEMP\$(New-Guid)"
New-Item -ItemType "Directory" -Path "$Workdir"
Set-Location -Path "$PSScriptRoot"
$Json = (Get-Content -Path "version.json" -Raw | ConvertFrom-Json)
Start-BitsTransfer -Source $Json.dist -Destination "$Workdir"
Get-ChildItem -Path "$WorkDir" | ForEach-Object {
	Expand-Archive -Path "$($_.FullName)" -DestinationPath "$WorkDir"
}
$EclipseDir="$WorkDir\eclipse"

$Repos = @(

	# Regular Eclipse repositories
	"https://download.eclipse.org/releases/2022-12",
	"https://download.eclipse.org/eclipse/updates/4.26",
	# "https://download.eclipse.org/e4/snapshots/org.eclipse.e4.ui",

	# C/C++ repository
	"https://download.eclipse.org/tools/cdt/releases/latest/",

	#DBeaver repsitory
	"https://dbeaver.io/update/git/latest/",
	"https://dbeaver.io/update/office/latest/",
	"https://dbeaver.io/update/latest/",

	# EGit repository
	"https://download.eclipse.org/egit/updates",

	# Jaspersoft Studio repository
	"http://jasperstudio.sourceforge.net/updates/",

	# SpringBoot repository
	"https://download.springsource.com/release/TOOLS/sts4/update/e4.26/",

	# SonarLint repository
	"https://eclipse-uc.sonarlint.org",

	# Additional artifacts
	"https://download.eclipse.org/tools/orbit/R-builds/R20210602031627/repository",
	"https://download.eclipse.org/tools/orbit/R-builds/R20210602031627/repository",
	"https://download.eclipse.org/releases/2022-03/202203161000",

	# Wild Web Developer HTML, CSS, JSON, Yaml, JavaScript, TypeScript, Node tools
	"http://download.eclipse.org/wildwebdeveloper/releases/latest/"
)

$FeatureList = @(

	# Jaspersoft studio
	"com.jaspersoft.studio.feature.feature.group",
	"net.sf.jasperreports.feature.feature.group",
	"net.sf.jasperreports.samples.feature.feature.group",
	"com.jaspersoft.studio.foundation.bundles.feature.group",

	# Marketplace client
	"org.eclipse.epp.mpc.feature.group",

	# Buildship Gradle plugin
	"org.eclipse.buildship.feature.group",

	# SonarLint code analysis 
	"org.sonarlint.eclipse.feature.feature.group",

	# Eclipse C/C++ development tools
	"org.eclipse.cdt.feature.group",

	# DBeaver database management
	"org.jkiss.dbeaver.debug.feature.feature.group",
	"org.jkiss.dbeaver.ui.feature.feature.group",
	"org.jkiss.dbeaver.git.feature.feature.group",
	"org.jkiss.dbeaver.ide.feature.feature.group",
	"org.jkiss.dbeaver.db.feature.feature.group",
	"org.jkiss.dbeaver.db.ui.feature.feature.group",
	"org.jkiss.dbeaver.ui.extra.feature.feature.group",
	"org.jkiss.dbeaver.runtime.feature.feature.group",
	"org.jkiss.dbeaver.ext.office.feature.feature.group",
	"org.jkiss.dbeaver.ext.ui.svg.feature.feature.group",

	# Spring Tool Suite
	"org.springframework.tooling.bosh.ls.feature.feature.group",
	"org.springframework.tooling.cloudfoundry.manifest.ls.feature.feature.group",
	"org.springframework.tooling.concourse.ls.feature.feature.group",
	"org.springframework.tooling.boot.ls.feature.feature.group",
	"org.springframework.ide.eclipse.boot.dash.feature.feature.group",
	"org.springframework.boot.ide.main.feature.feature.group",
	"org.springframework.ide.eclipse.xml.namespaces.feature.feature.group",

	# Git plugin
	"org.eclipse.egit.feature.group",

	# Web development tools
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

	# Wild Web Developer HTML, CSS, JSON, Yaml, JavaScript, TypeScript, Node tools
	"org.eclipse.wildwebdeveloper.feature.feature.group",
	
	# Maven plugin
	"org.eclipse.m2e.wtp.feature.feature.group"
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

$RepoListStr = Convert-ArrayToString -StringArray $Repos
$FeatureListStr = Convert-ArrayToString -StringArray $FeatureList

Start-Process `
-FilePath "$EclipseDir\eclipse.exe" `
-Wait `
-ArgumentList `
	"-application","org.eclipse.equinox.p2.director",`
	"-repository","$RepoListStr",`
	"-installIU","$FeatureListStr"

Write-Host "Setting configuration"

$EclipseIni = Get-Content -Raw -Path "$EclipseDir\eclipse.ini"
$EclipseIni = $EclipseIni.Replace("Xms40m", "Xms1024m")
$EclipseIni = $EclipseIni.Replace("Xmx512m", "Xmx4096m")
Set-Content -Path "$EclipseDir\eclipse.ini" -Value $EclipseIni
Set-Content -Path "$EclipseDir\p2\org.eclipse.equinox.p2.engine\profileRegistry\SDKProfile.profile\.data\.settings\org.eclipse.equinox.p2.ui.sdk.scheduler.prefs" -Value "enabled=true"

return $EclipseDir