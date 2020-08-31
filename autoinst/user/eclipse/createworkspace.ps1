param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkSpace = "$env:USERPROFILE\workspaces\NewWorkspace"
)

If (-Not (Test-Path -Path "$WorkSpace")) {
	New-Item -ItemType Directory -Path "$WorkSpace"
}

# Configure Workspace and automatic updates
$SettingsPath = "$WorkSpace\.metadata\.plugins\org.eclipse.core.runtime\.settings"

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