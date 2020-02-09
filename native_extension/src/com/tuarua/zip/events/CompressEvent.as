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
package com.tuarua.zip.events {
import flash.events.Event;

public class CompressEvent extends Event {
    public static const COMPLETE:String = "ZIPANE.OnCompressComplete";
    public var path:String;
    /** @private */
    public function CompressEvent(type:String, path:String = null,
                                  bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.path = path;
    }
    /** @private */
    public override function clone():Event {
        return new CompressEvent(type, this.path, bubbles, cancelable);
    }
    /** @private */
    public override function toString():String {
        return formatToString("CompressEvent", "type", "path", "bubbles", "cancelable");
    }

}
}
