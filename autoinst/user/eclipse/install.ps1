$WorkDir = "$env:TEMp\$(New-Guid)"
New-Item -ItemType "Directory" -Path "$Workdir"
Set-Location -Path "$PSScriptRoot"
$Json = (Get-Content -Path "version.json" -Raw | ConvertFrom-Json)
Start-BitsTransfer -Source $Json.dist -Destination "$Workdir"
Get-ChildItem -Path "$WorkDir" | ForEach-Object {
    Expand-Archive -Path "$($_.FullName)" -DestinationPath "$WorkDir"
}
$EclipseDir="$WorkDir\eclipse"

$Repos = @(
    "https://download.eclipse.org/releases/$($Json.release)/",
    "https://download.eclipse.org/tools/cdt/releases/10.5",
    "https://dbeaver.io/update/git/latest/",
    "https://dbeaver.io/update/office/latest/",
    "https://dbeaver.io/update/latest/",
    "https://download.eclipse.org/egit/github/updates",
    "https://download.eclipse.org/egit/github/updates-nightly",
    "https://download.eclipse.org/tools/orbit/downloads/drops/R20210825222808/repository",
    "https://download.eclipse.org/releases/$($Json.release)",
    "https://download.eclipse.org/egit/updates",
    "http://jasperstudio.sourceforge.net/updates/",
    "https://download.eclipse.org/e4/snapshots/org.eclipse.e4.ui",
    "https://download.springsource.com/release/TOOLS/sts4/update/e4.21",
    "https://download.eclipse.org/eclipse/updates/$($Json.version)",
    "https://eclipse-uc.sonarlint.org",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20211213173813/repository"
)

$FeatureList = @(
    "com.jaspersoft.studio.feature.feature.group",
    "net.sf.jasperreports.feature.feature.group",
    "net.sf.jasperreports.samples.feature.feature.group",
    "com.jaspersoft.studio.foundation.bundles.feature.group",
    "org.eclipse.epp.mpc.feature.group",
    "org.eclipse.buildship.feature.group",
    "org.eclipse.m2e.wtp.feature.feature.group",
    "org.eclipse.cdt.feature.group",
    "org.jkiss.dbeaver.ide.feature.feature.group",
    "org.jkiss.dbeaver.debug.feature.feature.group",
    "org.jkiss.dbeaver.git.feature.feature.group",
    "org.jkiss.dbeaver.ext.office.feature.feature.group",
    "org.jkiss.dbeaver.net.sshj.feature.feature.group",
    "org.jkiss.dbeaver.ext.ui.svg.feature.feature.group",
    "org.sonarlint.eclipse.feature.feature.group",
    "org.springframework.tooling.bosh.ls.feature.feature.group",
    "org.springframework.tooling.cloudfoundry.manifest.ls.feature.feature.group",
    "org.springframework.tooling.concourse.ls.feature.feature.group",
    "org.springframework.tooling.boot.ls.feature.feature.group",
    "org.springframework.ide.eclipse.boot.dash.feature.feature.group",
    "org.springframework.boot.ide.main.feature.feature.group",
    "org.springframework.ide.eclipse.xml.namespaces.feature.feature.group",
    "org.eclipse.egit.feature.group",
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
    "org.eclipse.jst.enterprise_ui.feature.feature.group"
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