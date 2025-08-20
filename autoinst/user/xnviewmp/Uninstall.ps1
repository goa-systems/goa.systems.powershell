Get-Process -Name "xnviewmp" -ErrorAction SilentlyContinue | Stop-Process
if(Test-Path -Path "${env:LOCALAPPDATA}\Programs\XnViewMP"){
    Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Programs\XnViewMP"
}
if(Test-Path -Path "${env:LOCALAPPDATA}\Microsoft\Windows\Start Menu\Programs\XnViewMP.lnk"){
    Remove-Item -Recurse -Force -Path "${env:LOCALAPPDATA}\Microsoft\Windows\Start Menu\Programs\XnViewMP.lnk"
}