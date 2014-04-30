#include "SensorMote.h"
 
module RFIDSensorC {
	uses {
		interface Receive;
		interface Memory;
		interface RadioFrequencySensor;
	}
	
	provides interface RFIDSensor;
}

implementation {
	RFID_test_message testMessage;
	
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if(len == sizeof(RFID_test_message)) {
			RFID_test_message* RFIDpkt = (RFID_test_message*)payload;
			dbg("RFIDSensorC", "[RFID] I'm going to eat'....\n");
			call RFIDSensor.eatFromFeedingSpot(RFIDpkt->feedingSpot);
		}	
		return msg;
	}

	command void RFIDSensor.eatFromFeedingSpot(nx_uint8_t feedingSpotID) {
		call Memory.updateFeedingSpotAfterEat(feedingSpotID);
		dbg("RFIDSensorC", "[RFID] Finished eating on feeding spot %hhu.\n", feedingSpotID);
		call RadioFrequencySensor.propagateUpdatesOfFeedingSpots(feedingSpotID, call Memory.getCurrentFoodAmount(feedingSpotID), TOS_NODE_ID, call Memory.getFoodEatenByMe());
	}
}