package com.tuarua.utils {
import flash.system.Capabilities;

public class os {
    private static const platform:String = Capabilities.version.substr(0, 3);
    public static const isWindows:Boolean = platform == "WIN";
    public static const isOSX:Boolean = platform == "MAC";
    public static const isAndroid:Boolean = platform == "AND";
    public static const isIos:Boolean = platform == "IOS";
}
}
