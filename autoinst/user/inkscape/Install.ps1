# $TagList = Invoke-RestMethod -Uri "https://gitlab.com/api/v4/projects/3472737/repository/tags"
# $Version = "$($TagList[0].name)".Substring("INKSCAPE_".Length).Replace("_",".")
# Write-Host "$($Version)"
# $Uri = "https://inkscape.org/release/inkscape-${Version}/windows/64-bit/compressed-7z/dl/"
# $Page = (Invoke-WebRequest -Uri "${Uri}").ToString()
# $Pattern = "<a href=`"(.*)`">click here</a>"
# $Page -match $Pattern
# $RelativeLink = $matches[1]
# $DownloadUrl = "https://inkscape.org${RelativeLink}"
# Start-BitsTransfer -Source "${DownloadUrl}" -Destination "."