param (
	# Array of strings
	[String[]]
	$StringArray = @("These","are","the","default","elements.")
)
$String = ""
for ($i = 0; $i -lt $StringArray.Count - 1; $i++) {
	$Element = $StringArray[$i]
	$String += "$Element,"
}
$String += $StringArray[$i]
return $String