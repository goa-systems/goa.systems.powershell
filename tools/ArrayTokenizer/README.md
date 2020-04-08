# ArrayTokenzier
This script concatenates a array of strings to a single string, separated by comma.

Default call without parameter:
```
.\ArrayTokenizer.ps1
These,are,the,default,elements.
```
Call with parameters. Quote character and delimiter modified. This puts out a CSV like line from a String array:
```
.\ArrayTokenizer.ps1 -StringArray @("Elem1","Elem2","Elem3") -QuoteChar "`"" -Delimiter ";"
"Elem1";"Elem2";"Elem3"
```
Same example, but output is saved a CSV file that can be opened with table calculation programs.
```
.\ArrayTokenizer.ps1 -StringArray @("Elem1","Elem2","Elem3") -QuoteChar "`"" -Delimiter ";" | Out-File "test.csv"
```