if(Test-Path -Path "${env:BLENDER_HOME}"){
    Remove-Item -Recurse -Force -Path "${env:BLENDER_HOME}"
}
[System.Environment]::SetEnvironmentVariable("BLENDER_HOME", "", [System.EnvironmentVariableTarget]::User)
Remove-ItemProperty -Path "HKCU:\Environment" -Name "BLENDER_HOME"