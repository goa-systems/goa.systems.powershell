param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "javacomplete"
)

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
	"org.eclipse.cdt.feature.group",
	"org.tigris.subversion.subclipse.feature.group",
	"org.tigris.subversion.subclipse.mylyn.feature.feature.group",
	"org.tigris.subversion.clientadapter.javahl.feature.feature.group",
	"org.tigris.subversion.subclipse.graph.feature.feature.group",
	"org.tigris.subversion.clientadapter.svnkit.feature.feature.group",
	"org.sonarlint.eclipse.feature.feature.group",
	"com.jaspersoft.studio.feature.feature.group"
)

$Repos = @(
	"http://download.eclipse.org/releases/2019-12",
	"http://download.eclipse.org/eclipse/updates/4.14",
	"https://download.springsource.com/release/TOOLS/sts4/update/e4.14/",
	"http://download.eclipse.org/buildship/updates/e411/releases/3.x",
	"https://download.eclipse.org/egit/updates",
	"http://jasperstudio.sourceforge.net/updates/",
	"https://nodeclipse.github.io/updates/",
	"https://dl.bintray.com/subclipse/releases/subclipse/latest/",
	"https://eclipse-uc.sonarlint.org"
)

# Required for Jaspersoft Studio. They are not automatically downloaded.
$AdditionalPlugins = @(
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.pool_1.6.0.v201204271246.jar",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/org.apache.commons.dbcp_1.4.0.v201204271417.jar",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.transaction_1.1.1.v201105210645.jar",
	"https://download.eclipse.org/releases/2019-09/201909181001/plugins/org.eclipse.wb.swt_1.9.1.201812270937.jar",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.xml.bind_2.2.0.v201105210648.jar",
	"https://download.eclipse.org/tools/orbit/downloads/drops/R20191115185527/repository/plugins/javax.activation_1.1.0.v201211130549.jar"
)

.\eclipse.ps1 -FeatureList $FeatureList -Repos $Repos -WorkingDirectory "$WorkingDirectory" -AdditionalPlugins $AdditionalPlugins

$path = "$WorkingDirectory\WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

If (-Not (Test-Path -Path "$path")) {
	New-Item -ItemType Directory -Path "$path"
}

# Enable Java save actions.
$file = "org.eclipse.jdt.ui.prefs"
Set-Content -Path "$path\$file" -Value "editor_save_participant_org.eclipse.jdt.ui.postsavelistener.cleanup=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.format_source_code=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.on_save_use_additional_actions=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.organize_imports=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.add_missing_annotations=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.add_missing_override_annotations=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.add_missing_override_annotations_interface_methods=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.add_missing_deprecated_annotations=true"
Add-Content -Path "$path\$file" -Value "sp_cleanup.remove_unnecessary_casts=true"
Add-Content -Path "$path\$file" -Value '<?xml version\="1.0" encoding\="UTF-8" standalone\="no"?><templates><template autoinsert\="false" context\="java-statements" deleted\="false" description\="try catch block" enabled\="true" id\="org.eclipse.jdt.ui.templates.try" name\="try_catch">try {\r\n\t${line_selection}${cursor}\r\n} catch (${Exception} ${exception_variable_name}) {\r\n\tlogger.error("General_error_template", ${exception_variable_name});\r\n}</template><template autoinsert\="true" context\="java" deleted\="false" description\="static Logger field using slf4j" enabled\="true" id\="org.springframework.ide.eclipse.boot.templates.slf4j.logger" name\="logger">\r\n${\:import(org.slf4j.Logger,org.slf4j.LoggerFactory)}\r\nprivate static final Logger ${log} \= LoggerFactory.getLogger(${enclosing_type}.class);\r\n</template><template autoinsert\="true" context\="java" deleted\="false" description\="try catch finally block" enabled\="true" name\="try_catch_finally">try {&\#13;\r\n\t${line_selection}${cursor}&\#13;\r\n} catch (${Exception} ${exception_variable_name}) {&\#13;\r\n\tlogger.error("General_error_template", ${exception_variable_name});&\#13;\r\n} finally {&\#13;\r\n\t&\#13;\r\n}</template></templates>'

<# Show a hint, if log file is larger than 3kb. #>
Get-ChildItem "$WorkingDirectory\Eclipse\configuration" | Where-Object {$_.Name -like "*.log"} | Where-Object {$_.Length -gt 3000} | ForEach-Object {
	Write-Host "Looks like an eror occured. Please check file $($_.FullName)"
}

<# Remove log files that are smaller than 3kb because that usually means, that the plugin was created successfully. #>
Get-ChildItem "$WorkingDirectory\Eclipse\configuration" | Where-Object {$_.Name -like "*.log"} | Where-Object {$_.Length -lt 3000} | ForEach-Object {
	Write-Host "Removing log file $($_.FullName)."
	Remove-Item -Path "$($_.FullName)"
}