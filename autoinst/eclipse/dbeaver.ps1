$FeatureList = @(
	"org.eclipse.epp.mpc.feature.group",
	"org.jkiss.dbeaver.ide.feature.feature.group",
	"org.jkiss.dbeaver.debug.feature.feature.group",
	"org.jkiss.dbeaver.git.feature.feature.group",
	"org.jkiss.dbeaver.ext.office.feature.feature.group",
	"org.jkiss.dbeaver.net.sshj.feature.feature.group",
	"org.jkiss.dbeaver.ext.ui.svg.feature.feature.group"
)

$Repos = @(
	"http://download.eclipse.org/releases/2019-09",
	"http://download.eclipse.org/eclipse/updates/4.13",
	"http://download.eclipse.org/usssdk/updates/release/latest",
	"https://dbeaver.io/update/latest/",
	"https://dbeaver.io/update/office/latest/",
	"https://dbeaver.io/update/git/latest/"
)

.\eclipse.ps1 -FeatureList $FeatureList -Repos $Repos -WorkingDirectory DBeaver