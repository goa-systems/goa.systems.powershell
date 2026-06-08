if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    $Destination = "$env:TEMP\$(New-Guid)"
    if(Test-Path -Path "${Destination}"){
        Remove-Item -Recurse -Force -Path "${Destination}"
    }
    New-Item -ItemType Directory -Path "${Destination}"

    $Response = Invoke-RestMethod -Uri "https://api.github.com/repos/ip7z/7zip/releases/latest"
    $Version = $Response.tag_name
    $ShortVersion = $Version -replace "\.",""

    Start-BitsTransfer -Source "https://github.com/ip7z/7zip/releases/download/${Version}/7z${ShortVersion}-x64.exe" -Destination "${Destination}"
    Get-ChildItem -Path "${Destination}" | ForEach-Object {
        Start-Process -FilePath "$($_.FullName)" -ArgumentList @("/S", "/D=`"${env:ProgramFiles}\7-Zip`"") -Wait
    }
    Remove-Item -Recurse -Force -Path "${Destination}"
} else {
	Start-Process -FilePath "pwsh.exe" -ArgumentList "$PSScriptRoot\$($MyInvocation.MyCommand.Name)" -Wait -Verb RunAs
}