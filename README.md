# Zip-ANE

Zip Adobe Air Native Extension for Windows, macOS, iOS 9.0+ and Android 19+.    
This ANE provides an identical cross platform API for creating and extracting .zip files   

[ASDocs Documentation](https://tuarua.github.io/asdocs/zipane/index.html)  

-------------
## Prerequisites

You will need:

- IntelliJ IDEA
- AIR 33.1.1.217+
- [.Net Core Runtime](https://dotnet.microsoft.com/download/dotnet-core/3.1)
- [AIR-Tools](https://github.com/tuarua/AIR-Tools/)

-------------


## Android

cd into /example-mobile and run the _"air-tools"_ command (You will need [AIR-Tools](https://github.com/tuarua/AIR-Tools/) installed)

```shell
air-tools install
```

-------------

## iOS


>N.B. You must use a Mac to build an iOS app using this ANE. Windows is **NOT** supported.


This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.

-------------

## Windows

### The ANE + Dependencies


From Terminal cd into /example-desktop and run the _"air-tools"_ command (You will need [AIR-Tools](https://github.com/tuarua/AIR-Tools/) installed)

```bash
air-tools install
```

##### Windows Installation - Important!

* This ANE was built with MS Visual Studio 2015. As such your machine (and user's machines) will need to have Microsoft Visual C++ 2015 Redistributable (x86) runtime installed.
https://www.microsoft.com/en-us/download/details.aspx?id=48145

* This ANE also uses .NET 4.6 Framework. As such your machine (and user's machines) will need to have to have this installed.
https://www.microsoft.com/en-us/download/details.aspx?id=48130

-------------

## macOS

From the command line cd into /example-desktop and run:

```shell
air-tools install
```

### Task List
- [x] Zip file creation
- [x] Zip file extraction
- [ ] Zip file information
- [ ] Zip file updating
- [x] Zip single entry extraction

### References
* [https://github.com/marmelroy/Zip]
* [https://kotlinlang.org/docs/reference/android-overview.html] 
