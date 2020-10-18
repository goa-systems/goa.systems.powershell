[CmdletBinding()]
param (
    # Path to inkscape executable
    [String]
    $InkscapeExe = "$env:ProgramFiles\Inkscape\bin\inkscape.exe",

    # Dimensions to convert to
    [Int[]]
    $Dimensions = @(8, 12, 16, 24, 32, 48, 64, 96, 128, 192, 256, 384, 512),

    # Export directory
    [String]
    $ImportDir = "Import",

    # Export directory
    [String]
    $ExportDir = "Export",

    # Export directory
    [String]
    $ExportPrefix = "custom"
)

Set-Location -Path "$PSScriptRoot"

if( -not (Test-Path -Path "${ExportDir}")){
    New-Item -ItemType "Directory" -Path "${ExportDir}"
}

Get-ChildItem -Path "$ImportDir" | ForEach-Object {
    
    $VectorGraphic = $_.FullName
    $TargetBaseName = $_.Name.Split('.')[0]

    foreach (${Dimension} in ${Dimensions}) {

        Write-Host -Object "Executing ${InkscapeExe} --export-type=png -w ${Dimension} -h ${Dimension} -o ${ExportDir}\${ExportPrefix}_${TargetBaseName}_${Dimension}.png ${VectorGraphic}"`

        Start-Process `
        -FilePath "${InkscapeExe}"`
        -ArgumentList @(`
            "--export-type=png", `
            "-w ${Dimension}", `
            "-h ${Dimension}", `
            "-o `"${ExportDir}\${ExportPrefix}_${TargetBaseName}_${Dimension}.png`"", `
            "`"${VectorGraphic}`"")
    }
}

