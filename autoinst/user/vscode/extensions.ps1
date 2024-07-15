$extensions=@("ms-vscode.powershell","idleberg.nsis","idleberg.nsis-plugins","ionutvmi.reg","redhat.vscode-xml","james-yu.latex-workshop","pkief.material-icon-theme")
ForEach($extension in $extensions){
    $expr = "`"$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd`" --install-extension `"$extension`""
    Invoke-Expression "&$expr"
}