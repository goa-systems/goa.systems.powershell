Get-Process | Where-Object {$_.Name -eq "HeidiSQL"} | ForEach-Object {
    Stop-Process -Name $_.Name
    Start-Sleep -Seconds 2
}

if(Test-Path -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\HeidiSQL.lnk"){
    Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\HeidiSQL.lnk"
}

if(Test-Path -Path "$env:LocalAppData\Programs\HeidiSQL"){
    Remove-Item -Path "$env:LocalAppData\Programs\HeidiSQL" -Recurse -Force
}