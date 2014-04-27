#include <Timer.h>
#include "SensorMote.h"
 
module SensorMoteC {
	uses {
		interface Boot;
		interface Timer<TMilli> as Timer;
		interface SplitControl as AMControl;
	}
}

implementation {
	uint16_t counter = 0;	

	event void Boot.booted() {
		dbg("SensorMoteC", "[BOOT] Boot fired || Counter is %hu.\n", counter);
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call Timer.startPeriodic(TIMER_PERIOD_MILLI);
		} else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {}
 
	event void Timer.fired() {
		counter++;
		dbg("SensorMoteC", "[TIMER] Timer fired || Counter is %hu.\n", counter);
	}
}
