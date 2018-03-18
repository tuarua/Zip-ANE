/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.zipane.events {
import flash.events.Event;

public class ExtractProgressEvent extends Event {
    public static const PROGRESS:String = "ZIPANE.OnExtractProgress";
    /** Path to the zip file */
    public var path:String;
    /** The path to the file which is about to be extracted */
    public var nextEntry:String;
    /** Number of bytes extracted */
    public var bytes:Number;
    /** This is the size of the zip uncompressed */
    public var bytesTotal:Number;
    /** @private */
    public function ExtractProgressEvent(type:String, path:String = null, bytes:Number = 0,
                                         bytesTotal:Number = 0, nextEntry:String = null,
                                         bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.path = path;
        this.nextEntry = nextEntry;
        this.bytes = bytes;
        this.bytesTotal = bytesTotal;
    }
    /** @private */
    public override function clone():Event {
        return new ExtractProgressEvent(type, this.path, this.bytes, this.bytesTotal,
                this.nextEntry, bubbles, cancelable);
    }
    /** @private */
    public override function toString():String {
        return formatToString("ExtractProgressEvent", "type", "path", "bytes", "nextEntry",
                "bytesTotal", "bubbles", "cancelable");
    }
}
}
