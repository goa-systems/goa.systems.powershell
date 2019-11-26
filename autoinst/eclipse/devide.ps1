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

.\eclipse.ps1 -FeatureList $FeatureList -Repos $Repos -WorkingDirectory DevIde

$path = "DevIde\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

If (-Not (Test-Path -Path "$path")) {
	New-Item -ItemType Directory -Path "$path"
}

# Disable theming and set to classic GUI
$file = "org.eclipse.jdt.ui.prefs"
Set-Content -Path "$path\$file" -Value "editor_save_participant_org.eclipse.jdt.ui.postsavelistener.cleanup=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.format_source_code=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.on_save_use_additional_actions=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.organize_imports=true"