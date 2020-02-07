param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkSpaceDir = "devide\Workspace\.metadata\.plugins\org.eclipse.core.runtime\.settings"
)

if(-not (Test-Path -Path "$WorkSpaceDir")) {
	New-Item -ItemType Directory -Path "$WorkSpaceDir"
}

# Disable theming and set to classic GUI
$file = "org.eclipse.e4.ui.workbench.renderers.swt.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkSpaceDir\$file" -Value "enableMRU=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "themeEnabled=false"

# Set line separator to linux style
$file = "org.eclipse.core.runtime.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkSpaceDir\$file" -Value "line.separator=`\n"

# Set workspace encoding to UTF-8
$file = "org.eclipse.core.resources.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkSpaceDir\$file" -Value "encoding=UTF-8"
Add-Content -Path "$WorkSpaceDir\$file" -Value "version=1"

# Don't show confirmation dialog on exit
$file = "org.eclipse.ui.ide.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "EXIT_PROMPT_ON_CLOSE_LAST_WINDOW=false"

# Don't show welcome screen on first startup
$file = "org.eclipse.ui.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "USE_COLORED_LABELS=false"
Add-Content -Path "$WorkSpaceDir\$file" -Value "eclipse.preferences.version=1"
Add-Content -Path "$WorkSpaceDir\$file" -Value "showIntro=false"

# Configure Java
$file = "org.eclipse.jdt.ui.prefs"
Set-Content -Path "$WorkSpaceDir\$file" -Value "editor_save_participant_org.eclipse.jdt.ui.postsavelistener.cleanup=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.format_source_code=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.on_save_use_additional_actions=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.organize_imports=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.add_missing_annotations=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.add_missing_override_annotations=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.add_missing_override_annotations_interface_methods=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.add_missing_deprecated_annotations=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value "sp_cleanup.remove_unnecessary_casts=true"
Add-Content -Path "$WorkSpaceDir\$file" -Value '<?xml version\="1.0" encoding\="UTF-8" standalone\="no"?><templates><template autoinsert\="false" context\="java-statements" deleted\="false" description\="try catch block" enabled\="true" id\="org.eclipse.jdt.ui.templates.try" name\="try_catch">try {\r\n\t${line_selection}${cursor}\r\n} catch (${Exception} ${exception_variable_name}) {\r\n\tlogger.error("General_error_template", ${exception_variable_name});\r\n}</template><template autoinsert\="true" context\="java" deleted\="false" description\="static Logger field using slf4j" enabled\="true" id\="org.springframework.ide.eclipse.boot.templates.slf4j.logger" name\="logger">\r\n${\:import(org.slf4j.Logger,org.slf4j.LoggerFactory)}\r\nprivate static final Logger ${log} \= LoggerFactory.getLogger(${enclosing_type}.class);\r\n</template><template autoinsert\="true" context\="java" deleted\="false" description\="try catch finally block" enabled\="true" name\="try_catch_finally">try {&\#13;\r\n\t${line_selection}${cursor}&\#13;\r\n} catch (${Exception} ${exception_variable_name}) {&\#13;\r\n\tlogger.error("General_error_template", ${exception_variable_name});&\#13;\r\n} finally {&\#13;\r\n\t&\#13;\r\n}</template></templates>'
