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

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var zipController: ZipController?

    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        zipController = ZipController(context: context)
        return true.toFREObject()
    }
    
    func compress(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let mc = zipController,
            let path = String(argv[0]),
            let directory = String(argv[1]),
            let safePath = URL.init(safe: path),
            let safeDirectory = URL.init(safe: directory)
            else {
                return ArgCountError(message: "compress").getError(#file, #line, #column)
        }
        mc.compress(path: safePath, directory: safeDirectory)
        return nil
    }
    
    func extract(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let mc = zipController,
            let path = String(argv[0]),
            let directory = String(argv[1]),
            let safePath = URL.init(safe: path),
            let safeDirectory = URL.init(safe: directory)
            else {
                return ArgCountError(message: "compress").getError(#file, #line, #column)
        }
        mc.extract(path: safePath, directory: safeDirectory)
        return nil
    }
     
}
