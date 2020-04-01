
if(Test-Path -Path "$env:TEMP\DevIde") {
    Remove-Item -Path "$env:TEMP\DevIde" -Force -Recurse
}

if(-not (Test-Path -Path "$env:LOCALAPPDATA\Programs\Eclipse")){
    New-Item -Path "$env:LOCALAPPDATA\Programs\Eclipse" -ItemType "Directory"
}

if(-not (Test-Path -Path "$env:USERPROFILE\workspaces")){
    New-Item -Path "$env:USERPROFILE\workspaces" -ItemType "Directory"
}

.\devide.ps1 -WorkingDirectory "$env:TEMP\DevIde" -ModifyWorkspace $false

Move-Item -Path "$env:TEMP\DevIde\Eclipse" -Destination "$env:LOCALAPPDATA\Programs\Eclipse\4.16" -Force
Move-Item -Path "$env:TEMP\DevIde\WorkSpace" -Destination "$env:USERPROFILE\workspaces\java_auto" -Force

..\insttools\CreateShortcut.ps1 `
-LinkName "Eclipse" `
-TargetPath "`"%LOCALAPPDATA%\Programs\Eclipse\4.16\eclipse.exe`"" `
-Arguments "-data `"%USERPROFILE%\workspaces\java_auto`"" `
-IconFile "%LOCALAPPDATA%\Programs\Eclipse\4.16\eclipse.exe" `
-IconId 0 `
-Description "Eclipse IDE" `
-WorkingDirectory "`"%UserProfile%`"" `
-ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs","$env:USERPROFILE\Desktop")