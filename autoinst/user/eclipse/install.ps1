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
    "http://download.eclipse.org/releases/2021-12",
    "http://download.eclipse.org/eclipse/updates/4.22",
    "https://download.eclipse.org/buildship/updates/e422/releases/3.x",
    "https://eclipse-uc.sonarlint.org",
    "https://dbeaver.io/update/latest/",
    "https://dbeaver.io/update/office/latest/",
    "https://dbeaver.io/update/git/latest/",
    # "http://jasperstudio.sourceforge.net/updates",
    "https://eclipse-uc.sonarlint.org",
    "https://download.springsource.com/release/TOOLS/sts4/update/e4.21",
    "https://download.eclipse.org/egit/updates"
)

$FeatureList = @(
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
    # "com.jaspersoft.studio.feature.feature.group",
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

$AdditionalPlugins = @(
    # "https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.pool_1.6.0.v201204271246.jar",
    # "https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.dbcp_1.4.0.v201204271417.jar",
    # "https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.transaction_1.1.1.v201105210645.jar",
    # "https://download.eclipse.org/releases/2019-09/201909181001/plugins/org.eclipse.wb.swt_1.9.1.201812270937.jar",
    # "https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.xml.bind_2.2.0.v201105210648.jar",
    # "https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.activation_1.1.0.v201211130549.jar"
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

foreach($Plugin in $AdditionalPlugins){
	try {
		Start-BitsTransfer -Source "$Plugin" -Destination "$EclipseDir\plugins" -ErrorAction Stop
		Start-Sleep -Seconds 2
	} catch {
		Write-Error -Message "There has been a download error with the url ${Plugin}."
		$PluginInstallSuccess = $PluginInstallSuccess -and $false
	}
}

Start-Process `
-FilePath "$EclipseDir\eclipse.exe" `
-Wait `
-ArgumentList `
    "-application","org.eclipse.equinox.p2.director",`
    "-repository","$RepoListStr",`
    "-installIU","$FeatureListStr"