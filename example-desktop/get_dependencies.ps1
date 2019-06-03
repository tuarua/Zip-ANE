$AneVersion = "1.3.0"
$FreSwiftVersion = "3.1.0"
$FreSharpVersion = "2.2.0"

$currentDir = (Get-Item -Path ".\" -Verbose).FullName
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/FreSwift.ane?raw=true -OutFile "$currentDir\..\native_extension/ane/FreSwift.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/Zip-ANE/releases/download/$AneVersion/ZipANE.ane?raw=true -OutFile "$currentDir\..\native_extension\ane\ZipANE.ane"
Invoke-WebRequest -Uri https://github.com/tuarua/FreSharp/releases/download/$FreSharpVersion/FreSharp.ane?raw=true -OutFile "$currentDir\..\native_extension\ane\FreSharp.ane"