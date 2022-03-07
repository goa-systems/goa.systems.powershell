Set-Location -Path "$PSScriptRoot"

$Json = ConvertFrom-Json -InputObject (Get-Content -Raw -Path "version.json")
$EclipseDir = $(.\download.ps1)

if( -Not (Test-Path -Path "$env:LocalAppData\Programs\Eclipse")){
	New-Item -ItemType "Directory" -Path "$env:LocalAppData\Programs\Eclipse"
}

Move-Item -Path "$($EclipseDir[1])" -Destination "$env:LocalAppData\Programs\Eclipse\$($Json.version)"