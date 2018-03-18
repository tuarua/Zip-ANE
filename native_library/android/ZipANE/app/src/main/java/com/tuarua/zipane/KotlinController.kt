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
package com.tuarua.zipane

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController {

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun compress(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        val path = String(argv[0]) ?: return FreException("cannot convert path").getError(arrayOf())
        val directory = String(argv[1]) ?: return FreException("cannot convert path").getError(arrayOf())
        val tsk = CompressTask(path, directory, context)
        tsk.execute()
        return null
    }

    fun extract(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        val path = String(argv[0]) ?: return FreException("cannot convert path").getError(arrayOf())
        val to = String(argv[1]) ?: return FreException("cannot convert directory").getError(arrayOf())
        val tsk = ExtractTask(path, to, context)
        tsk.execute()
        return null
    }

    override val TAG: String
        get() = this::class.java.simpleName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
        }
}