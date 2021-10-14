$DownloadDir = "$env:USERPROFILE\Downloads\Eclipse"

.\eclipse.ps1 -WorkingDirectory "$DownloadDir"
.\spring.ps1 -WorkingDirectory "$DownloadDir"
.\buildsys.ps1 -WorkingDirectory "$DownloadDir"
.\c_cpp.ps1 -WorkingDirectory "$DownloadDir"
.\database.ps1 -WorkingDirectory "$DownloadDir"
# .\jasper.ps1 -WorkingDirectory "$DownloadDir"
.\sonarlint.ps1 -WorkingDirectory "$DownloadDir"
.\versioning.ps1 -WorkingDirectory "$DownloadDir"
.\web.ps1 -WorkingDirectory "$DownloadDir"