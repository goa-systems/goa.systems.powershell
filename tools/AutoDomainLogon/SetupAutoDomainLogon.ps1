param (

	[Parameter(Mandatory=$true)]
	[String]
	$DefaultDomainName,

	[Parameter(Mandatory=$true)]
	[String]
	$DefaultUserName,

	[Parameter(Mandatory=$true)]
	[Security.SecureString]
	$DefaultPassword
)

$LiteralPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

function Save-ItemProperty {
	param (
		[Parameter(Mandatory=$true)]
		[String]
		$Key,

		[Parameter(Mandatory=$true)]
		[String]
		$Val
	)
	if (Get-ItemProperty -LiteralPath "$LiteralPath" -Name "$Key" -ea SilentlyContinue) {
		Write-Host -Object "Updating property"
		Set-ItemProperty -LiteralPath "$LiteralPath" -Name "$Key" -Value "$Val" 
	} else {
		Write-Host -Object "Saving property"
		New-ItemProperty -LiteralPath "$LiteralPath" -Name "$Key" -Value "$Val" | Out-Null
	}
}

$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $DefaultUserName, $DefaultPassword

Save-ItemProperty -Key "DefaultDomainName" -Val "$DefaultDomainName"
Save-ItemProperty -Key "DefaultUserName" -Val "$DefaultUserName"
Save-ItemProperty -Key "DefaultPassword" -Val $Credentials.GetNetworkCredential().Password
Save-ItemProperty -Key "AutoAdminLogon" -Val "1"