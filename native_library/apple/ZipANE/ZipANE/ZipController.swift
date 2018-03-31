/* Copyright 2018 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import FreSwift

class ZipController: NSObject, FreSwiftController {
    var TAG: String? = "ZipController"
    var context: FreContextSwift!
    internal let backgroundQueue = DispatchQueue(label: "com.tuarua.zipane.backgroundQueue", qos: .background)
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
    }
    
    func compress(path: URL, directory: URL) {
        backgroundQueue.async {
            do {
                try Zip.zipFiles(paths: [directory], zipFilePath: path, password: nil,
                             progress: { (bytes, bytesTotal, file) -> Void in
                                var props: [String: Any] = Dictionary()
                                props["path"] = path.path
                                props["bytes"] = bytes
                                props["bytesTotal"] = bytesTotal
                                props["nextEntry"] = file
                                self.sendEvent(name: CompressProgressEvent.PROGRESS, value: JSON(props).description)
                },
                             complete: {
                                var props: [String: Any] = Dictionary()
                                props["path"] = path.path
                                self.sendEvent(name: CompressEvent.COMPLETE, value: JSON(props).description)
                })

            } catch let e {
                var props: [String: Any] = Dictionary()
                props["path"] = path.path
                props["message"] = e.localizedDescription
                self.sendEvent(name: ZipErrorEvent.ERROR, value: JSON(props).description)
            }
        }
    }

    func extract(path: URL, directory: URL, entryPath: String? = nil) {
        backgroundQueue.async {
            do {
                try Zip.unzipFile(path, destination: directory, overwrite: true, password: nil, entryPath: entryPath,
                                  progress: { (bytes, bytesTotal, file) -> Void in
                                    var props: [String: Any] = Dictionary()
                                    props["path"] = path.path
                                    props["bytes"] = bytes
                                    props["bytesTotal"] = bytesTotal
                                    props["nextEntry"] = file
                                    self.sendEvent(name: ExtractProgressEvent.PROGRESS, value: JSON(props).description)

                },
                                  complete: {
                                    var props: [String: Any] = Dictionary()
                                    props["path"] = path.path
                                    self.sendEvent(name: ExtractEvent.COMPLETE, value: JSON(props).description)
                })
            } catch let e {
                var props: [String: Any] = Dictionary()
                props["path"] = path.path
                props["message"] = e.localizedDescription
                self.sendEvent(name: ZipErrorEvent.ERROR, value: JSON(props).description)
            }
        }
    }
    
}
