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
import com.tuarua.zipane.data.CompressProgressEvent
import com.tuarua.zipane.data.CompressEvent
import com.tuarua.zipane.data.ZipErrorEvent
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

class CompressTask(private val path: String,
                   private val directory: String,
                   override var context: FREContext?) : AsyncTask<String, Int, String>(), FreKotlinController {
    private val gson = Gson()
    private var fileList = mutableListOf<Pair<String, Long>>()
    private var bytesTotal: Long = 0L
    override fun doInBackground(vararg params: String): String? {
        try {
            val fileOutputStream = FileOutputStream(path)
            val zipOutputStream = ZipOutputStream(fileOutputStream)
            val directoryFile = File(directory)
            getFileList(directoryFile.listFiles())
            var bytes = 0L
            for (file in fileList) {
                val fileName = file.first.substring(directory.length + 1)
                sendEvent(CompressProgressEvent.PROGRESS,
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
            sendEvent(CompressProgressEvent.PROGRESS, gson.toJson(CompressProgressEvent(path, bytesTotal, bytesTotal)))
        } catch (e: Exception) {
            sendEvent(ZipErrorEvent.ERROR, gson.toJson(ZipErrorEvent(path, e.message)))
        }
        return null
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

    override fun onPostExecute(unused: String?) {
        sendEvent(CompressEvent.COMPLETE, gson.toJson(CompressEvent(path)))
        fileList.clear()
    }

    override val TAG: String
        get() = this::class.java.simpleName
}