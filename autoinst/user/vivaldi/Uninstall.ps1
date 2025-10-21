
$UninstallString = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Vivaldi -Name UninstallString).UninstallString
if (-Not [string]::IsNullOrEmpty($UninstallString)) {
    Invoke-Expression "&$UninstallString --force-uninstall"
}
