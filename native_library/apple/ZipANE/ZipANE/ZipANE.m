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

#import <Foundation/Foundation.h>
#import "FreMacros.h"
#import "ZipANE_oc.h"
#ifdef OSX
#import <ZipANE/ZipANE-Swift.h>
#else
#import <ZipANE_FW/ZipANE_FW.h>
#define FRE_OBJC_BRIDGE TRZIP_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end
#endif
@implementation ZipANE_LIB
SWIFT_DECL(TRZIP) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(TRZIP) {
    SWIFT_INITS(TRZIP)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRZIP, init)
        ,MAP_FUNCTION(TRZIP, compress)
        ,MAP_FUNCTION(TRZIP, extract)
        ,MAP_FUNCTION(TRZIP, extractEntry)
    };
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRZIP) {
    [TRZIP_swft dispose];
    TRZIP_swft = nil;
#ifdef OSX
#else
    TRZIP_freBridge = nil;
    TRZIP_swftBridge = nil;
#endif
    TRZIP_funcArray = nil;
}
EXTENSION_INIT(TRZIP)
EXTENSION_FIN(TRZIP)
@end
