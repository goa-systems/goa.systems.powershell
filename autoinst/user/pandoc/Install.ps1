$Response = Invoke-RestMethod -Uri "https://api.github.com/repos/jgm/pandoc/releases/latest"
$Assets = $Response.assets

foreach($Asset in $Assets){
    if($Asset.name -match "windows" -and $Asset.name -match "x86_64" -and $Asset.name -match "\.zip"){
        $Url = "$($Asset.browser_download_url)"
        $TempDir = "${env:TEMP}\$(New-Guid)"
        if(Test-Path -Path "${TempDir}"){
            Remove-Item -Force -Recurse -Path "${TempDir}"
        }
        New-Item -ItemType "Directory" -Path "${TempDir}"
        Start-BitsTransfer -Source "${Url}" -Destination "${TempDir}\$($Asset.name)"
        if( -Not (Test-Path -Path "${env:LOCALAPPDATA}\Programs\Pandoc")){
            New-Item -ItemType "Directory" -Path "${env:LOCALAPPDATA}\Programs\Pandoc"
        }
        Expand-Archive -Path "${TempDir}\$($Asset.name)" -DestinationPath "${env:LOCALAPPDATA}\Programs\Pandoc"
        Get-ChildItem -Path "${env:LOCALAPPDATA}\Programs\Pandoc" | ForEach-Object {
            [System.Environment]::SetEnvironmentVariable("PANDOC_HOME", "$($_.FullName)", [System.EnvironmentVariableTarget]::User)
        }
        Remove-Item -Force -Recurse -Path "${TempDir}"
    }
}