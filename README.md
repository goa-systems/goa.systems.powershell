# PowerShell

## About

This project offers a few useful powershell scripts. I am trying to sort them as good as possible and document them in this and other .md files.

## Content

### autoinst

This folder contains automated installation scripts for tools I currently use.

#### eclipse

The eclipse scripts offer a way to individually conigure Eclipse based on the current platform version. Therefor the basic Eclipse platform is downloaded and modified by the script. At the moment the scripts offer two workloads.

* dbeaver - For database manipulation and administration.
* dev - A complete IDE environment with SpringBoot, Git, Jaspersoft Studio, SonarLint, Web-, XML- Json and other software development tools.

For installation of features a functionality called "org.eclipse.equinox.p2.director" is used.

The scripts have to be executed in PowerShell. Working directory is 
```
"$env:ProgramData\InstSys\eclipse"
```
which usually translates to
```
"C:\ProgramData\InstSys\eclipse"
```

After the script is done the software is located at 
```
"$env:ProgramData\InstSys\eclipse\Eclipse"
```
and a workspace is configured under
```
"$env:ProgramData\InstSys\eclipse\WorkSpace"
```
This can be used as template because line endings, encoding and theming are already configured.

**Possible errors**

Sometimes a update server is not reachable. So please check the directory
```
"$env:ProgramData\InstSys\eclipse\Eclipse\configuration"
```
for *.log files. Normally per feature a log file is created and has a size of around 3kb. If there was an error and a exception is thrown the log file has the size of 6kb or more. Then check which feature has failed and install it manually.
