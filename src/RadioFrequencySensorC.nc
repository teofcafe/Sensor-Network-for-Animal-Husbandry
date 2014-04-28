#include "SensorMote.h"
#include "Memory.h"

module RadioFrequencySensorC {
	uses {
		interface Packet;
		interface AMPacket;
		interface Receive;
		interface GPSCoordinateSensor as MyCoordinate;
		interface Memory;
		interface AMSend;
		interface SplitControl as AMControl;
	}
}

implementation{
	uint16_t hierarchyLevel = 0;
	bool firstMessage = TRUE, busy = FALSE;
	message_t pkt;
	uint16_t foodEaten = 10;
	
	
	void SendBroadcastMessage() {
		MoteInformationMessage* mmpkt = (MoteInformationMessage*)(call Packet.getPayload(&pkt, sizeof (MoteInformationMessage)));
	
		mmpkt->x = call MyCoordinate.getCoordX();
		mmpkt->y = call MyCoordinate.getCoordY();
		mmpkt ->nodeID = TOS_NODE_ID;
		mmpkt -> foodEaten = foodEaten;
		mmpkt ->senderNodeId = TOS_NODE_ID;
		mmpkt -> senderNodeHierarchyLevel = hierarchyLevel;
	
		dbg("RadioFrequencySensorC", "Starting BROADCAST message...\n");
	
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoteInformationMessage)) == SUCCESS) {
			dbg("RadioFrequencySensorC", "Success BROADCAST message...\n");	
			busy = TRUE;
			firstMessage = FALSE;
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	
		if(len == sizeof(FeedingSpotMessage)) {
			FeedingSpotMessage* feedingSpotpkt = (FeedingSpotMessage*) payload;
			call Memory.setCurrentFoodAmount(feedingSpotpkt->feedingSpotID, feedingSpotpkt->foodAmount);
		}
	
		else if(len == sizeof(request_msg)) {
			dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE] Received request message.\n");
	
			hierarchyLevel = 1;
	
			if (!busy)
				if(firstMessage)
				SendBroadcastMessage();
		}

		return msg;
	}

		event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			;
		}
		else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
}