$vscodeexe = "vscode.exe"

If(-Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\vscode")){
    New-Item -Path "$env:SystemDrive\ProgramData\InstSys\vscode" -ItemType "Directory"
}

<# Download Libreoffice, if setup is not found in execution path. #>
if( -Not (Test-Path -Path "$env:SystemDrive\ProgramData\InstSys\vscode\$vscodeexe")){
    Start-BitsTransfer `
    -Source "https://aka.ms/win32-x64-user-stable" `
    -Destination "$env:SystemDrive\ProgramData\InstSys\vscode\$vscodeexe"
}

Start-Process -Wait -FilePath "$env:SystemDrive\ProgramData\InstSys\vscode\$vscodeexe" -ArgumentList "/SILENT","/MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath"