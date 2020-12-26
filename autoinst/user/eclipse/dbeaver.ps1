param (
	# The working directory. Default ProgramData\instsys\eclipse
	[String] $WorkingDirectory = "dbeaver"
)

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
	"http://download.eclipse.org/releases/2020-12",
	"http://download.eclipse.org/eclipse/updates/4.18",
	"http://download.eclipse.org/usssdk/updates/release/latest",
	"https://dbeaver.io/update/latest/",
	"https://dbeaver.io/update/office/latest/",
	"https://dbeaver.io/update/git/latest/"
)

.\eclipse.ps1 -FeatureList $FeatureList -Repos $Repos -WorkingDirectory "$WorkingDirectory"

<# Show a hint, if log file is larger than 3kb. #>
Get-ChildItem "$WorkingDirectory\Eclipse\configuration" | Where-Object {$_.Name -like "*.log"} | Where-Object {$_.Length -gt 3000} | ForEach-Object {
	Write-Host "Looks like an eror occured. Please check file $($_.FullName)"
}

<# Remove log files that are smaller than 3kb because that usually means, that the plugin was created successfully. #>
Get-ChildItem "$WorkingDirectory\Eclipse\configuration" | Where-Object {$_.Name -like "*.log"} | Where-Object {$_.Length -lt 3000} | ForEach-Object {
	Write-Host "Removing log file $($_.FullName)."
	Remove-Item -Path "$($_.FullName)"
}