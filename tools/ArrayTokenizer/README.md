# ArrayTokenzier
This script concatenates a array of strings to a single string, separated by comma.

Default call without parameter:
```
.\ArrayTokenizer.ps1
These,are,the,default,elements.
```
Call with parameter:
```
.\ArrayTokenizer.ps1 -StringArray @("Hello","World")
Hello,World
```