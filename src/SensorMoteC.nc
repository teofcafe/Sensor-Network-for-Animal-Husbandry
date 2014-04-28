#include <Timer.h>
#include "SensorMote.h"
 
module SensorMoteC {
	uses {
		interface Boot;
		interface SplitControl as AMControl;
	}
}

implementation {

	event void Boot.booted() {
		dbg("SensorMoteC", "[BOOT] Boot fired.\n");
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			; //TODO
		} else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {}

}
