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

import android.os.AsyncTask
import com.adobe.fre.FREContext
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.zipane.data.ExtractProgressEvent
import com.tuarua.zipane.data.CompressEvent
import com.tuarua.zipane.data.ExtractEvent
import com.tuarua.zipane.data.ZipErrorEvent
import java.io.File
import java.util.zip.ZipFile

class ExtractTask(private val path: String,
                  private val to: String,
                  private val entryPath: String?,
                  override var context: FREContext?) : AsyncTask<String, Int, String>(), FreKotlinController {
    private val gson = Gson()

    override fun doInBackground(vararg params: String): String? {
        var bytesTotal = 0L
        var bytes = 0L
        var entryPath = entryPath
        try {
            ZipFile(path).use { zip ->
                for (entry in zip.entries()) {
                    bytesTotal += entry.size
                }
            }
            ZipFile(path).use { zip ->
                for (entry in zip.entries()) {
                    if (!entryPath.isNullOrEmpty()) {
                        entryPath = entryPath?.replace("\\", "/")
                        if (entryPath == entry.name.replace("\\", "/")) {
                            bytesTotal = entry.size
                        } else {
                            continue
                        }
                    }

                    dispatchEvent(ExtractProgressEvent.PROGRESS,
                            gson.toJson(ExtractProgressEvent(path, bytes, bytesTotal, entry.name)))
                    bytes += entry.size
                    if (entry.isDirectory) {
                        createDirectory("/${entry.name}")
                    } else {
                        zip.getInputStream(entry).use { input ->
                            val entryCleaned = entry.name.replace("\\", "/")
                            val fullPath = "$to/$entryCleaned"
                            if (!File(fullPath.substringBeforeLast("/")).exists()) {
                                createDirectory("/${entryCleaned.substringBeforeLast("/")}")
                            }
                            File(fullPath).outputStream().use { output ->
                                input.copyTo(output)
                            }
                        }
                    }
                    if (!entryPath.isNullOrEmpty() && entryPath == entry.name) {
                        break
                    }
                }
                dispatchEvent(ExtractProgressEvent.PROGRESS, gson.toJson(ExtractProgressEvent(path, bytesTotal, bytesTotal)))
            }
        } catch (e: Exception) {
            dispatchEvent(ZipErrorEvent.ERROR, gson.toJson(ZipErrorEvent(path, e.message)))
        }
        return null
    }

    override fun onPreExecute() {
        super.onPreExecute()
        createDirectory("")
    }

    override fun onPostExecute(unused: String?) {
        dispatchEvent(ExtractEvent.COMPLETE, gson.toJson(CompressEvent(path)))
    }

    override val TAG: String
        get() = this::class.java.simpleName

    private fun createDirectory(dir: String) {
        val f = File(to + dir)
        if (!f.isDirectory) {
            f.mkdirs()
        }
    }
}
