param (
    [String]
    $IdfPath = "$env:LOCALAPPDATA\Programs\Espressif\Idf",
    
    [String]
    $IdfToolsPath = "$env:LOCALAPPDATA\Programs\Espressif\Tools"
)

$env:IDF_PATH = $IdfPath
$env:IDF_TOOLS_PATH = $IdfToolsPath
git clone --recursive https://github.com/espressif/esp-idf.git $env:IDF_PATH
."$env:IDF_PATH\install.ps1"
."$env:IDF_TOOLS_PATH\python_env\idf4.3_py3.8_env\Scripts\python.exe" -m pip install --upgrade pip
."$env:IDF_PATH\export.ps1"