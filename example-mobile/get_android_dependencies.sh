#!/bin/sh

AneVersion="0.0.5"

wget -O android_dependencies/com.tuarua.frekotlin.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-2.8.4.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-2.8.4.ane?raw=true
wget -O ../native_extension/ane/ZipANE.ane https://github.com/tuarua/Zip-ANE/releases/download/$AneVersion/ZipANE.ane?raw=true
