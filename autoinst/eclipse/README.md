# Eclipse: Download and configure unattended

The eclipse scripts offer a way to individually conigure Eclipse based on the current platform version. For installation of features a functionality called "org.eclipse.equinox.p2.director" is used.

The scripts use certain parameters that have default values. Those parameters are:

* $FeatureList (default: Marketplace client)
* $Repos (default: Eclipse repositories)
* $WorkingDirectory (default: "$env:ProgramData\InstSys\eclipse")

These parameters define, what workload and in which directory Eclipse and the workspace is installed.

## Workloads

Multiple workloads are defined in different script files.

| Script file | Workload |
| --- | --- |
| eclipse.ps1 | Basic eclipse installation with Marketplace client. |
| buildsys.ps1 | Eclipse with build systems integration. Integrated are Gradle and Maven. |
| c_cpp.ps1 | C/C++ build tools for Eclipse. |
| complete.ps1 | Eclipse installation with all tools. |
| database.ps1 | DBeaver database management integration. |
| jasper.ps1 | JasperSoft Studio integration for creating and editing reports. |
| sonarlint.ps1 | Integration of SonarLint code analysis. |
| spring.ps1 | Integration of SpringToolSuite. |
| versioning.ps1 | Integration of Git, Subversion and CVS clients. |
| web.ps1 | Integration of Web- and XML editors and tools. |

It is recommended to install all tools and specify the usage in the workspace. E.g. if in the Java workspace the database tools are not required they can be deselected in the perspective customization dialog:

Menu bar: "Window" > "Perspective" > "Customize Perspective..." > Tab "Action Set Availability"

There the database tools can be deslected and won't show up in the menu bar anymore.

## Possible errors and troubleshooting

Sometimes a update server is not reachable. So please check the directory
```
"$env:ProgramData\InstSys\eclipse\Eclipse\configuration"
```
for *.log files. Normally per feature a log file is created and has a size of around 3kb. If there was an error and a exception is thrown the log file has the size of 6kb or more. Then check which feature has failed and install it manually.
