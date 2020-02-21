#!/bin/sh

AneVersion="1.5.0"
FreSwiftVersion="4.3.0"
FreSharpVersion="2.4.0"

wget -O ../native_extension/ane/FreSwift.ane https://github.com/tuarua/Swift-IOS-ANE/releases/download/$FreSwiftVersion/FreSwift.ane?raw=true
wget -O ../native_extension/ane/ZipANE.ane https://github.com/tuarua/Zip-ANE/releases/download/$AneVersion/ZipANE.ane?raw=true
wget -O ../native_extension/ane/FreSharp.ane https://github.com/tuarua/FreSharp/releases/download/$FreSharpVersion/FreSharp.ane?raw=true
