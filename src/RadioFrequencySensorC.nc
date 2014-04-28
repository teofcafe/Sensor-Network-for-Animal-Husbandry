#include "SensorMote.h"
#include "Memory.h"

module RadioFrequencySensorC {
	uses {
		interface Packet;
		interface AMPacket;
		interface Receive;
		interface GPSCoordinateSensor as MyCoordinate;
		interface Memory;
	}
}

implementation{

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	
		if(len == sizeof(FeedingSpotMessage)) {
			FeedingSpotMessage* feedingSpotpkt = (FeedingSpotMessage*) payload;
			call Memory.setCurrentFoodAmount(feedingSpotpkt->feedingSpotID, feedingSpotpkt->foodAmount);
		}
		
		else if(len == sizeof(request_msg)) {
			dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE] Received request message.\n");
	
		}

		return msg;
	}
}