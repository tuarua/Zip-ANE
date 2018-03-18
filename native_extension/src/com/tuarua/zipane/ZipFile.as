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
package com.tuarua.zipane {
import com.tuarua.ZipANEContext;
import com.tuarua.fre.ANEError;
import com.tuarua.zipane.events.CompressProgressEvent;
import com.tuarua.zipane.events.ExtractEvent;
import com.tuarua.zipane.events.ExtractProgressEvent;
import com.tuarua.zipane.events.CompressEvent;
import com.tuarua.zipane.events.ZipErrorEvent;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.filesystem.File;

public class ZipFile extends EventDispatcher {
    /** @private */
    private var path:String;
    //private var _numFiles:int;
    // private var _uncompressedSize:Number = -1;
    /** @private */
    private var file:File;
    /** @private */
    private var argsAsJSON:Object;

    /** Creates a ZipFile reference.
     *
     * @param file The path to the zip file
     */
    public function ZipFile(file:File) {
        if (file == null || getExtension(file) != "zip") {
            throw new ArgumentError("path must be of file type zip");
        }
        this.file = file;
        this.path = file.nativePath;
    }

    /** Creates a zip.
     *
     * @param directory Directory to create the zip file from
     */
    public function compress(directory:File):void {
        if (!directory.exists) {
            trace("directory doesn't exist");
            return;
        }
        ZipANEContext.context.addEventListener(StatusEvent.STATUS, gotEvent);
        var theRet:* = ZipANEContext.context.call("compress", path, directory.nativePath);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /** Extracts the zip.
     *
     * @param to Directory to extract the zip's files to
     */
    public function extract(to:File):void {
        ZipANEContext.context.addEventListener(StatusEvent.STATUS, gotEvent);
        var theRet:* = ZipANEContext.context.call("extract", path, to.nativePath);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    /** implements File.deleteFile() */
    public function deleteFile():void {
        if (file && file.exists) {
            file.deleteFile();
        }
    }

    /** implements File.deleteFileAsync() */
    public function deleteFileAsync():void {
        if (file && file.exists) {
            file.deleteFileAsync();
        }
    }

    /** Returns the size of the .zip file */
    public function get size():Number {
        return file && file.exists ? file.size : -1;
    }

    /** Whether the .zip file exists */
    public function get exists():Boolean {
        return file ? file.exists : false;
    }

   /* // entries.length
    public function get numFiles():int {
        return _numFiles;
    }*/

    // convert to "entries"
    /*public function get uncompressedSize():Number {
        if (_uncompressedSize > -1) return _uncompressedSize;
        if (file == null || !file.exists) return -1;
        var theRet:* = ZipANEContext.context.call("uncompressedSize", path);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        _uncompressedSize = theRet as Number;
        return _uncompressedSize;
    }*/

    /** @private */
    private function gotEvent(event:StatusEvent):void {
        // trace(event.level, event.code);
        switch (event.level) {
            case ExtractEvent.COMPLETE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.path != this.path) return;
                    this.dispatchEvent(new ExtractEvent(event.level, this.path));
                    dispose();
                } catch (e:Error) {
                    trace("JSON decode error", e.message);
                    break;
                }
                break;
            case CompressEvent.COMPLETE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.path != this.path) return;
                    this.dispatchEvent(new CompressEvent(event.level, this.path));
                    dispose();
                } catch (e:Error) {
                    trace("JSON decode error", e.message);
                    break;
                }
                break;
            case ExtractProgressEvent.PROGRESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.path != this.path) return;
                    this.dispatchEvent(new ExtractProgressEvent(event.level, this.path,
                            argsAsJSON.bytes,
                            argsAsJSON.bytesTotal,
                            argsAsJSON.nextEntry));
                } catch (e:Error) {
                    trace("JSON decode error", e.message);
                    break;
                }
                break;
            case CompressProgressEvent.PROGRESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.path != this.path) return;
                    this.dispatchEvent(new CompressProgressEvent(event.level, this.path,
                            argsAsJSON.bytes,
                            argsAsJSON.bytesTotal,
                            argsAsJSON.nextEntry));
                } catch (e:Error) {
                    trace("JSON decode error", e.message);
                    break;
                }
                break;
            case ZipErrorEvent.ERROR:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.path != this.path) return;
                    this.dispatchEvent(new ZipErrorEvent(ZipErrorEvent.ERROR, this.path, false, false, argsAsJSON.message));
                    dispose();
                } catch (e:Error) {
                    trace("JSON decode error", e.message);
                    break;
                }
                break;
        }
    }

    /** @private */
    private function dispose():void {
        ZipANEContext.context.removeEventListener(StatusEvent.STATUS, gotEvent);
    }

    /** @private */
    private static function getExtension(file:File):String {
        var split:String = file.url.split("?")[0];
        return split.substring(split.lastIndexOf(".") + 1, split.length);
    }

}
}
