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
import flash.events.ErrorEvent;

public class ZipErrorEvent extends ErrorEvent {
    public static const ERROR:String = "ZIPANE.Error";
    public var path:String;
    public function ZipErrorEvent(type:String, path:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0) {
        super(type, bubbles, cancelable, text, id);
        this.path = path;
    }
}
}