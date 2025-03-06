# DBeaver user installer

Installs the latest version (based on the GitHub releases API) of DBeaver into `%LOCALAPPDATA%\Programs\DBeaver\<version>`. A start menu shortcut is created if it does not already exist. The uninstaller removes the currently installed version (defined via environment variable `%DVEAVER_HOME%`) and removes the start menu shortcut.