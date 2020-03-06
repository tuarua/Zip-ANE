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
import com.google.gson.Gson
import com.tuarua.frekotlin.*
import com.tuarua.zipane.data.*

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

import java.util.zip.ZipFile
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST")
class KotlinController : FreKotlinMainController {
    private val bgContext: CoroutineContext = Dispatchers.Default
    private val gson = Gson()
    private var fileList = mutableListOf<Pair<String, Long>>()
    private var bytesTotal: Long = 0L

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun compress(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return FreArgException()
        val directory = String(argv[1]) ?: return FreArgException()

        GlobalScope.launch(bgContext) {
            try {
                val fileOutputStream = FileOutputStream(path)
                val zipOutputStream = ZipOutputStream(fileOutputStream)
                val directoryFile = File(directory)
                getFileList(directoryFile.listFiles())
                var bytes = 0L
                for (file in fileList) {
                    val fileName = file.first.substring(directory.length + 1)
                    dispatchEvent(CompressProgressEvent.PROGRESS,
                            gson.toJson(CompressProgressEvent(path, bytes, bytesTotal, fileName)))
                    bytes += file.second
                    val fileInputStream = FileInputStream(file.first)
                    val zipEntry = ZipEntry(fileName)
                    zipOutputStream.putNextEntry(zipEntry)
                    fileInputStream.buffered().use {
                        it.copyTo(zipOutputStream)
                    }
                    zipOutputStream.closeEntry()
                }
                zipOutputStream.close()
                dispatchEvent(CompressProgressEvent.PROGRESS,
                        gson.toJson(CompressProgressEvent(path, bytesTotal, bytesTotal)))
            } catch (e: Exception) {
                dispatchEvent(ZipErrorEvent.ERROR, gson.toJson(ZipErrorEvent(path, e.message)))
            }
            dispatchEvent(CompressEvent.COMPLETE, gson.toJson(CompressEvent(path)))
            fileList.clear()
            bytesTotal = 0
        }
        return null
    }


    fun extract(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return FreArgException()
        val to = String(argv[1]) ?: return FreArgException()
        extract(path, to)
        return null
    }

    fun extractEntry(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val path = String(argv[0]) ?: return FreArgException()
        val entryPath = String(argv[1]) ?: return FreArgException()
        val to = String(argv[2]) ?: return FreArgException()
        extract(path, to, entryPath)
        return null
    }

    private fun extract(path: String, to: String, entryPath: String? = null) {
        bytesTotal = 0L
        var bytes = 0L
        var ePath = entryPath
        GlobalScope.launch(bgContext) {
            try {
                createDirectory(to, "")
                ZipFile(path).use { zip ->
                    for (entry in zip.entries()) {
                        bytesTotal += entry.size
                    }
                }
                ZipFile(path).use { zip ->
                    for (entry in zip.entries()) {
                        if (!ePath.isNullOrEmpty()) {
                            ePath = ePath?.replace("\\", "/")
                            if (ePath == entry.name.replace("\\", "/")) {
                                bytesTotal = entry.size
                            } else {
                                continue
                            }
                        }

                        dispatchEvent(ExtractProgressEvent.PROGRESS,
                                gson.toJson(ExtractProgressEvent(path, bytes, bytesTotal, entry.name)))
                        bytes += entry.size
                        if (entry.isDirectory) {
                            createDirectory(to, "/${entry.name}")
                        } else {
                            zip.getInputStream(entry).use { input ->
                                val entryCleaned = entry.name.replace("\\", "/")
                                val fullPath = "$to/$entryCleaned"
                                if (!File(fullPath.substringBeforeLast("/")).exists()) {
                                    createDirectory(to,
                                            "/${entryCleaned.substringBeforeLast("/")}")
                                }
                                File(fullPath).outputStream().use { output ->
                                    input.copyTo(output)
                                }
                            }
                        }
                        if (!ePath.isNullOrEmpty() && ePath == entry.name) {
                            break
                        }
                    }
                    dispatchEvent(ExtractProgressEvent.PROGRESS,
                            gson.toJson(ExtractProgressEvent(path, bytesTotal, bytesTotal)))
                }
            } catch (e: Exception) {
                dispatchEvent(ZipErrorEvent.ERROR, gson.toJson(ZipErrorEvent(path, e.message)))
            }
            dispatchEvent(ExtractEvent.COMPLETE, gson.toJson(CompressEvent(path)))
        }

    }

    private fun getFileList(files: Array<File>) {
        for (file in files) {
            if (file.isDirectory) {
                getFileList(file.listFiles())
            } else {
                bytesTotal += file.length()
                fileList.add(Pair<String, Long>(file.path, file.length()))
            }
        }
    }

    private fun createDirectory(to: String, dir: String) {
        val f = File(to + dir)
        if (!f.isDirectory) {
            f.mkdirs()
        }
    }

    override val TAG: String?
        get() = this::class.java.simpleName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }
}