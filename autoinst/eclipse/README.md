# Eclipse: Download and configure unattended

The eclipse scripts offer a way to individually conigure Eclipse based on the current platform version. Therefor the basic Eclipse platform is downloaded and modified by the script. At the moment the scripts offer two workloads.

* **dbeaver** - For database manipulation and administration.
* **devide** - A complete IDE environment with C/C++, SpringBoot, Git, Jaspersoft Studio, SonarLint, Web-, XML- Json and other software development tools.
* **jmc** - JDK/Java Mission Control: a surveilance environment to inspect and monitor Java applications.

For installation of features a functionality called "org.eclipse.equinox.p2.director" is used.

The scripts use the file "eclipse.ps1" and run it with certain parameters. Those parameters are:

* $FeatureList (default: Marketplace client)
* $Repos (default: Eclipse repositories)
* $WorkingDirectory (default: "$env:ProgramData\InstSys\eclipse")

These parameters define, what workload and in which directory Eclipse and the workspace is installed.

**Possible errors**

Sometimes a update server is not reachable. So please check the directory
```
"$env:ProgramData\InstSys\eclipse\Eclipse\configuration"
```
for *.log files. Normally per feature a log file is created and has a size of around 3kb. If there was an error and a exception is thrown the log file has the size of 6kb or more. Then check which feature has failed and install it manually.
