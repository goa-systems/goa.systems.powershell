if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Set-Location -Path "$PSScriptRoot"
    $Destination = "$env:TEMP\$(New-Guid)"
    New-Item -ItemType Directory -Path "$Destination"
    Start-BitsTransfer -Source "$((Get-Content -Raw -Path version.json | ConvertFrom-Json).download)" -Destination "$Destination"
    Get-ChildItem -Path "$Destination" | ForEach-Object {
        Start-Process -FilePath "$($_.FullName)" -ArgumentList @("/S", "/D=`"${env:ProgramFiles}\7-Zip`"") -Wait
    }
    Remove-Item -Recurse -Force -Path "$Destination"
} else {
	Start-Process -FilePath "powershell" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}