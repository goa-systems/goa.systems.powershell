Set-Location -Path $PSScriptRoot
$env:AS_JAVA = "" # Path to Java
$PayaraInstDir = "" # Path to Payara
$Servers = @('127.0.0.1:8048')
$PWFile = "$env:TEMP\payara.pw"
Set-Content -Path "$PWFile" -Value "AS_ADMIN_PASSWORD=payara" # Temporary default password.
ForEach($Server in $Servers){

    $Def = $Server.Split(':')
    $Server = $Def[0]
    $Port = $Def[1]

    Start-Process -FilePath "$PayaraInstDir\bin\asadmin.bat" -Wait -NoNewWindow -ArgumentList "--user admin --host $Server --port $Port --passwordfile=$PWFile create-custom-resource --factoryClass=org.glassfish.resources.custom.factory.PrimitivesAndStringFactory --resType=java.lang.String --description=`"Path to data folder on the harddrive.`" --enabled=true --target=domain GLOBAL/datapath"
    Start-Process -FilePath "$PayaraInstDir\bin\asadmin.bat" -Wait -NoNewWindow -ArgumentList "--user admin --host $Server --port $Port --passwordfile=$PWFile create-resource-ref --enabled=true --target=server GLOBAL/datapath"
    Start-Process -FilePath "$PayaraInstDir\bin\asadmin.bat" -Wait -NoNewWindow -ArgumentList "--user admin --host $Server --port $Port --passwordfile=$PWFile set resources.custom-resource.GLOBAL/datapath.property.value=/var/lib/payara/data"
    Start-Process -FilePath "$PayaraInstDir\bin\asadmin.bat" -Wait -NoNewWindow -ArgumentList "--user admin --host $Server --port $Port --passwordfile=$PWFile set resources.custom-resource.GLOBAL/datapath.property.value.description=`"Path to data folder on the harddrive.`""
}
Remove-Item -Path "$PWFile" -Force