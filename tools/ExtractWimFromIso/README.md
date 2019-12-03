# Wim extractor

Extracts a wim image with the give index (default is 1) to a defined destination wim file (default is install.wim in the execution directory) from a defined iso file (default is "Windows.iso").

## Error handling

Script checks, if image is a ".esd" or ".wim" file and mounts the correct file.

## Examples 

The following code has all three parameters specified.
```
.\Extract-WimFromIso.ps1 -SourceIso .\Windows10_en-US.iso -SourceIndex 3 -TargetWim C:\target.wim
```

<span style="color:red">**Attention:** Has to be executed as Administrator.</span>