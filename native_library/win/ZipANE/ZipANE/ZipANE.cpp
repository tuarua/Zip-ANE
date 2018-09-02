#include "FreSharpMacros.h"
#include "ZipANE.h"
#include "FreSharpBridge.h"

extern "C" {
	CONTEXT_INIT(TRZIP) {
		FREBRIDGE_INIT

		static FRENamedFunction extensionFunctions[] = {
			 MAP_FUNCTION(init)
			,MAP_FUNCTION(compress)
			,MAP_FUNCTION(extract)
			,MAP_FUNCTION(extractEntry)
		};

		SET_FUNCTIONS
	}

	CONTEXT_FIN(TRZIP) {
		FreSharpBridge::GetController()->OnFinalize();
	}
	EXTENSION_INIT(TRZIP)
	EXTENSION_FIN(TRZIP)

}

