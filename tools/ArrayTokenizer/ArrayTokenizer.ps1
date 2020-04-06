param (
	# Array of strings
	[String[]]
	$StringArray = @("These","are","the","default","elements."),

	# The default delimiter
	[String]
	$Delimiter = ",",

	# The default delimiter
	[String]
	$QuoteChar = ""
)
$String = ""
for ($i = 0; $i -lt $StringArray.Count - 1; $i++) { 
	$String += "${QuoteChar}$($StringArray[$i])${QuoteChar}$Delimiter"
}
$String += "${QuoteChar}$($StringArray[$i])${QuoteChar}"
return $String