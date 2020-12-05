..\..\insttools\CreateShortcut.ps1 `
    -LinkName "KeePassXC saved password" `
    -TargetPath "`"pwsh.exe`""`
    -Arguments "-Command `"&{'password' | . '$env:LOCALAPPDATA\Programs\KeePassXC\KeePassXC.exe' --pw-stdin '\\path\to\passwords.kdbx'}`""`
    -IconFile "$env:LOCALAPPDATA\Programs\KeePassXC\KeePassXC.exe" `
    -IconId 0 `
    -Description "KeePassXC with predefined passwor" `
    -WorkingDirectory "%UserProfile%" `
    -ShortcutLocations @("$env:AppData\Microsoft\Windows\Start Menu\Programs")