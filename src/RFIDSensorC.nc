#include "RFIDSensor.h"
#include "SensorMote.h"
 
module RFIDSensorC {
	uses {
		interface Receive;
		interface Memory;
	}
	
	provides {
		interface RFIDSensor;
	}
}

implementation {
	RFID_test_message testMessage;
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	
		if(len == sizeof(RFID_test_message)) {
			RFID_test_message* RFIDpkt = (RFID_test_message*)payload;
			dbg("RFIDSensorC", "[RFID] Received test order to eat.\n");
			call RFIDSensor.eatFromFeedingSpot(RFIDpkt->feedingSpot, RFIDpkt->quantityToEat);
		}	

		return msg;
	}

	command void RFIDSensor.eatFromFeedingSpot(nx_uint16_t feedingSpotID, nx_uint8_t quantity){
		call Memory.updateFeedingSpotAfterEat(feedingSpotID, quantity);
	}

}