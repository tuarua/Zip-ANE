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
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.zip.ZipFile
import java.util.zip.ZipInputStream

class ExtractTask(private val path: String,
                  private val to: String,
                  private val entryPath: String?,
                  override var context: FREContext?) : AsyncTask<String, Int, String>(), FreKotlinController {
    private val gson = Gson()

    override fun doInBackground(vararg params: String): String? {
        try {
            val zipFile = ZipFile(path)
            var bytesTotal = 0L
            for (e in zipFile.entries()) {
                bytesTotal += e.size
            }

            var bytes = 0L
            val fileInputStream = FileInputStream(path)
            val zipInputStream = ZipInputStream(fileInputStream)
            var entryPath = entryPath
            for (entry in zipInputStream) {
                if(!entryPath.isNullOrEmpty()) {
                    entryPath = entryPath?.replace("/","\\")
                    if (entryPath == entry.name) {
                        bytesTotal = entry.size
                    } else {
                        continue
                    }
                }

                sendEvent(ExtractProgressEvent.PROGRESS,
                        gson.toJson(ExtractProgressEvent(path, bytes, bytesTotal, entry.name)))
                bytes += entry.size
                if (entry.isDirectory) {
                    createDirectory(entry.name)
                } else {
                    val fileOutputStream = FileOutputStream(to + entry.name)
                    var c = zipInputStream.read()
                    while (c != -1) {
                        fileOutputStream.write(c)
                        c = zipInputStream.read()
                    }
                    zipInputStream.closeEntry()
                    fileOutputStream.close()
                }
                if(!entryPath.isNullOrEmpty() && entryPath == entry.name) {
                    break
                }
            }
            zipInputStream.close()
            sendEvent(ExtractProgressEvent.PROGRESS, gson.toJson(ExtractProgressEvent(path, bytesTotal, bytesTotal)))
        } catch (e: Exception) {
            sendEvent(ZipErrorEvent.ERROR, gson.toJson(ZipErrorEvent(path, e.message)))
        }
        return null
    }

    override fun onPreExecute() {
        super.onPreExecute()
        createDirectory("")
    }

    override fun onPostExecute(unused: String?) {
        sendEvent(ExtractEvent.COMPLETE, gson.toJson(CompressEvent(path)))
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
