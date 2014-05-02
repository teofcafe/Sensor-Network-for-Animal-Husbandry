#include "GPSCoordinateSensor.h"
#include "SensorMote.h"
 
module GPSCoordinateSensorC {
	uses interface Receive;
	provides interface GPSCoordinateSensor;
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
	
			dbg("GPSCoordinateSensorC", "[GPS] I'm at (%hhu, %hhu).\n", GPSpkt->x, GPSpkt->y);

			coordinate.x = (uint8_t)GPSpkt->x;
			coordinate.y = (uint8_t)GPSpkt->y;
		}
		
		return msg;
	}
	
	command void GPSCoordinateSensor.walk() {
		coordinate.x = (uint8_t)((rand() % ( (coordinate.x + 5 +1 )- (coordinate.x - 5)))+ (coordinate.x - 5) );
		coordinate.y = (uint8_t)((rand() % ( (coordinate.y + 5 +1 )- (coordinate.y - 5)))+ (coordinate.y - 5) );
	
		dbg("GPSCoordinateSensorC", "[GPS] Now I'm at (%hhu, %hhu).\n", coordinate.x, coordinate.y);
		
	}
}