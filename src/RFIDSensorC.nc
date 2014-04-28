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
			dbg("RFIDSensorC", "....[RFID] Received test order to eat....\n");
			dbg("RFIDSensorC", "....[RFID] Force animal to eat, food provided....\n");
			call RFIDSensor.eatFromFeedingSpot(RFIDpkt->feedingSpot);
			dbg("RFIDSensorC", "....[RFID]Animal Finish eating....\n");
			dbg("RFIDSensorC", "....[RFID]Move Update To persistent Memory of device....\n");
		}	

		return msg;
	}

	command void RFIDSensor.eatFromFeedingSpot(nx_uint8_t feedingSpotID){
		call Memory.updateFeedingSpotAfterEat(feedingSpotID);
	}

}