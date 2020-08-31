param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "jmc"
)

$FeatureList = @(
	"org.eclipse.epp.mpc.feature.group",
	"org.openjdk.jmc.feature.flightrecorder.metadata.feature.group",
	"org.openjdk.jmc.feature.flightrecorder.ext.jfx.feature.group",
	"org.openjdk.jmc.feature.jconsole.feature.group",
	"org.openjdk.jmc.feature.rcp.update.feature.group"
)

$Repos = @(
	"http://download.eclipse.org/releases/2019-09",
	"http://download.eclipse.org/eclipse/updates/4.13",
	"https://download.oracle.com/technology/products/missioncontrol/updatesites/openjdk/7.0.0/rcp",
	"https://download.oracle.com/technology/products/missioncontrol/updatesites/oracle/7.0.0/rcp"
)

.\eclipse.ps1 -FeatureList $FeatureList -Repos $Repos -WorkingDirectory "$WorkingDirectory"