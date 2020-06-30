$DirectoryContainingFiles = ""
$AbsolutePathToZipFile = ""

$ParamList = New-Object System.Collections.ArrayList 
<# Add default 7z parameters #>
$ParamList.Add("a")
$ParamList.Add("-tzip")
$ParamList.Add("-mm=Deflate")
$ParamList.Add("-mmt=on")
$ParamList.Add("-mx5")
$ParamList.Add("-mfb=32")
$ParamList.Add("-mpass=1")
$ParamList.Add("-sccUTF-8")
$ParamList.Add("-mem=AES256")
$ParamList.Add("-bb0")
$ParamList.Add("-bse0")
$ParamList.Add("-bsp2")
$ParamList.Add("`"$AbsolutePathToZipFile`"")

<# Generate a list of files from a given directory to add to the archive. #>
Get-ChildItem -Path "$DirectoryContainingFiles" | ForEach-Object {
    $ParamList.Add("`"" + $_.FullName + "`"")
}
Start-Process -FilePath "7z" -ArgumentList $ParamList.ToArray() -Wait -NoNewWindow