# Zip-ANE

Zip Adobe Air Native Extension for Windows, OSX, iOS 9.0+ and Android 19+.    
This ANE provides an identical cross platform API for creating and extracting .zip files   

[ASDocs Documentation](https://tuarua.github.io/asdocs/zipane/index.html)  

-------------

Much time, skill and effort has gone into this. Help support the project

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

-------------

### Usage
```actionscript
// Create a new zip file. 
var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme_created.zip"));
zipFile.addEventListener(CompressProgressEvent.PROGRESS, onCompressProgress);
zipFile.addEventListener(CompressEvent.COMPLETE, onCompressComplete);
var zipSource:File = File.applicationStorageDirectory.resolvePath("zipme");
zipFile.compress(zipSource);

private function onCompressProgress(event:CompressProgressEvent):void {
    trace(event);
}

private function onCompressComplete(event:CompressEvent):void {
    trace(event);
}

// extract a zip file
var zipFile:ZipFile = new ZipFile(File.applicationStorageDirectory.resolvePath("zipme.zip"));
zipFile.extract(File.applicationStorageDirectory.resolvePath("output"));

``` 

-------------

## Windows

#### The ANE + Dependencies

From the command line cd into /example-desktop and run:
```shell
PS get_dependencies.ps1
```

##### Windows Installation - Important!
* Copy the contents of the "c_sharp_libs_x86" folder into the bin folder of your AIRSDK. 

The location of this will vary depending on your IDE. These dlls need to reside in the folder where adl.exe is run from.

* This ANE was built with MS Visual Studio 2015. As such your machine (and user's machines) will need to have Microsoft Visual C++ 2015 Redistributable (x86) runtime installed.
https://www.microsoft.com/en-us/download/details.aspx?id=48145

* This ANE also uses .NET 4.6 Framework. As such your machine (and user's machines) will need to have to have this installed.
https://www.microsoft.com/en-us/download/details.aspx?id=48130

* For release builds, the c_sharp_libs_x86 files need to be packaged in the same folder as your exe.  
It is highly recommended you package your app for release using an installer.  

##### Windows 64bit

AIR29 now includes 32bit and 64bit in the AIR SDK.
However it appears adl.exe is 32bit only. Therefore when debugging use x86 version of the csharp dlls.

If you are using the 64bit version for release follow the above instructions replacing x86 with x64 where applicable


## OSX

#### The ANE + Dependencies

From the command line cd into /example-desktop and run:

```shell
bash get_dependencies.sh
```

## Android

#### The ANE + Dependencies

cd into /example-mobile and run:
- OSX (Terminal)
```shell
bash get_android_dependencies.sh
```
- Windows Powershell
```shell
PS get_android_dependencies.ps1
```

```xml
<extensions>
<extensionID>com.tuarua.frekotlin</extensionID>
<extensionID>org.jetbrains.kotlinx.kotlinx-coroutines-android</extensionID>
<extensionID>com.tuarua.ZipANE</extensionID>
<extensionID>com.google.code.gson.gson</extensionID>
...
</extensions>
```

You will also need to include the following in your app manifest. Update accordingly.

```xml
<manifest>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
</manifest>
```

-------------

## iOS

#### The ANE + Dependencies

N.B. You must use a Mac to build an iOS app using this ANE. Windows is NOT supported.

From the command line cd into /example-mobile and run:

```shell
bash get_ios_dependencies.sh
```

This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.

### Modifications to AIR SDK

We need to patch some files in AIR SDK. 

1. Copy adt.jar from **AIRSDK_patch** into the corresponding folder in your AIR SDK.
2. Delete ld64 in your AIR SDK from `/lib/aot/bin/ld64/ld64`
3. in Terminal:
`ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld /PATH/TO/YOUR/AIRSDK_32/lib/aot/bin/ld64/ld64` 

### Prerequisites

You will need:

- IntelliJ IDEA / Flash Builder
- AIR 32
- Android Studio 3 if you wish to edit the Android source
- wget on OSX
- Powershell on Windows

### Task List
- [x] Zip file creation
- [x] Zip file extraction
- [ ] Zip file information
- [ ] Zip file updating
- [x] Zip single entry extraction

### References
* [https://github.com/marmelroy/Zip]
* [https://kotlinlang.org/docs/reference/android-overview.html] 
