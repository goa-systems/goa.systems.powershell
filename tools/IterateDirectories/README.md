# Directory iterator
Iterates over a Folder and shows content, that is not in the ExclusionList string variable. The "|" in the string means "or".

## Default directory
"$env:SystemDrive\Users"

## Default exlusion list
""Public|All Users|desktop.ini""

## Default output
With no parameters.
```
.\IterateDirectories.ps1
C:\Users\user1
C:\Users\user2
```
With parameters on the script directory.
```
.\IterateDirectories.ps1 -Directory . -ExclusionList "IterateDirectories.ps1" 
.\README.md
```