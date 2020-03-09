# Autoinst
This directory contains scripts to (un)install or update software.
## Troubleshooting
### Untrusted files
To prevent warning messages about untrusted files execute the file "UnblockScripts.ps1" in the root directory first. It iterates over all scripts and unblocks them for further use.
```powershell
PS C:\workspace\powershell> .\autoinst\UnblockScripts.ps1
Unblocking file C:\workspace\powershell\autoinst\eclipse\eclipse.ps1
Unblocking file C:\workspace\powershell\autoinst\eclipse\jmc.ps1
...
```
### Execution policy
You may have to set your execution policy before using the scripts.

If you want to restore your original execution policiy after using the scripts, evaluate it first with the command "Get-ExecutionPolicy", note it down and apply it after the work is done.
```powershell
PS C:\> Get-ExecutionPolicy
Restricted
```
Run the following command with administrator privileges.
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
```
Apply the original execution policy.
```powershell
Set-ExecutionPolicy -ExecutionPolicy Restricted -Force
```
