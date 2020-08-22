#!/bin/sh

AneVersion="1.7.0"
FreKotlinVersion="1.40.0"
GsonVersion="2.8.6"
KotlinxCoroutinesVersion="1.3.9"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/org.jetbrains.kotlinx.kotlinx-coroutines-android-$KotlinxCoroutinesVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O ../native_extension/ane/ZipANE.ane https://github.com/tuarua/Zip-ANE/releases/download/$AneVersion/ZipANE.ane?raw=true
