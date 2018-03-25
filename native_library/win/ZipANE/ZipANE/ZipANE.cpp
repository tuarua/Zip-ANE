#include "FreSharpMacros.h"
#include "ZipANE.h"
#include "FreSharpBridge.h"

extern "C" {
	CONTEXT_INIT(TRZIP) {
		FREBRIDGE_INIT

		/**************************************************************************/
		/******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS MAINCONTROLLER.CS *****/
		/**************************************************************************/

		static FRENamedFunction extensionFunctions[] = {
			 MAP_FUNCTION(init)
			,MAP_FUNCTION(compress)
			,MAP_FUNCTION(extract)
			,MAP_FUNCTION(extractEntry)
			//,MAP_FUNCTION(uncompressedSize)
		};

		SET_FUNCTIONS
	}

	CONTEXT_FIN(TRZIP) {
		FreSharpBridge::GetController()->OnFinalize();
	}
	EXTENSION_INIT(TRZIP)
	EXTENSION_FIN(TRZIP)

}

