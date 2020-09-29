param (
    [String]
    $IdfPath = "$env:LOCALAPPDATA\Programs\Espressif\Idf",
    
    [String]
    $IdfToolsPath = "$env:LOCALAPPDATA\Programs\Espressif\Tools"
)

$env:IDF_PATH = $IdfPath
$env:IDF_TOOLS_PATH = $IdfToolsPath

if(Test-Path -Path "$env:IDF_PATH") {
    Remove-Item -Path "$env:IDF_PATH" -Recurse -Force
}

if(Test-Path -Path "$env:IDF_TOOLS_PATH") {
    Remove-Item -Path "$env:IDF_TOOLS_PATH" -Recurse -Force
}