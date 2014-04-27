#include "GPSCoordinateSensor.h"
#include "SensorMote.h"
 
module GPSCoordinateSensorC {
	uses {
		interface Receive;
	}
	
	provides {
		interface GPSCoordinateSensor;
	}
}

implementation {
	uint16_t counter = 0;
	GPSCoordinate coordinate;

	command uint8_t GPSCoordinateSensor.getCoordX(){
		return coordinate.x;
	}

	command uint8_t GPSCoordinateSensor.getCoordY(){
		return coordinate.y;
	}
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	
		if(len == sizeof(GPSCoordinateMessage)) {
			GPSCoordinateMessage* GPSpkt = (GPSCoordinateMessage*)payload;
	
			dbg("GPSCoordinateSensorC", "[GPS] Received coordinate (%hhu, %hhu).\n", GPSpkt->x, GPSpkt->y);

			coordinate.x = GPSpkt->x;
			coordinate.y = GPSpkt->y;
		}

		return msg;
	}
}