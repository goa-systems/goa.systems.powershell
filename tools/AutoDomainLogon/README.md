# Auto login setter
Sets the auto login for a user.
```powershell
.\SetupAutoDomainLogon.ps1 -DefaultDomainName "Domain FQDN" -DefaultUserName "sAMAccountName" -DefaultPassword (Read-Host -Prompt "Your domain password please" -AsSecureString)
```