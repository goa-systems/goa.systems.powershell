param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkSpaceDir = "devide\Workspace\.metadata\.plugins\org.eclipse.core.runtime\.settings"
)

if(-not (Test-Path -Path "$WorkSpaceDir")) {
	New-Item -ItemType Directory -Path "$WorkSpaceDir"
}

$configfiles = @(
	"org.eclipse.core.resources.prefs",
	"org.eclipse.core.runtime.prefs",
	"org.eclipse.e4.ui.workbench.renderers.swt.prefs",
	"org.eclipse.ui.editors.prefs",
	"org.eclipse.ui.ide.prefs",
	"org.eclipse.ui.prefs",
	"org.eclipse.jdt.ui.prefs"
)

foreach($file in $configfiles){
	Copy-Item -Path "conf\$file" -Destination "$WorkSpaceDir\$file"
}