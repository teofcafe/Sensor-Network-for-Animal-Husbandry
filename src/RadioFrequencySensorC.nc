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
		interface PacketAcknowledgements as Ack;
	}
}

implementation{
	int hierarchyLevel = 0;
	bool firstMessage = TRUE, busy = FALSE;
	message_t pkt;
	uint8_t foodEaten = 0;
	
	
	void SendBroadcastMessage() {
		MoteInformationMessage* mmpkt = (MoteInformationMessage*)(call Packet.getPayload(&pkt, sizeof (MoteInformationMessage)));
	
		mmpkt->x = call MyCoordinate.getCoordX();
		mmpkt->y = call MyCoordinate.getCoordY();
		mmpkt->nodeID = TOS_NODE_ID;
		mmpkt->foodEaten = foodEaten;
		mmpkt->senderNodeId = TOS_NODE_ID;
		mmpkt->senderNodeHierarchyLevel = hierarchyLevel;
		mmpkt->reply = 0;
	
		dbg("RadioFrequencySensorC", "Starting BROADCAST message...\n");
	
		//call Ack.requestAck(&pkt);
	
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
	
		else if (len == sizeof(MoteInformationMessage)) {
			MoteInformationMessage* mmpkt = (MoteInformationMessage*)payload;
	
			dbg("RadioFrequencySensorC", "[MOTE-MESSAGE] NODE %hhu IS ON (%hhu, %hhu) -> SENDED BY %hhu [%hhu].\n", mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->senderNodeId, mmpkt->senderNodeHierarchyLevel);
	
			call Memory.insertNewMoteInformation(mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->foodEaten, mmpkt->senderNodeId, mmpkt->senderNodeHierarchyLevel);

			if(mmpkt->reply == 0) {
				if(mmpkt->senderNodeHierarchyLevel + 1 < hierarchyLevel || hierarchyLevel == 0) {
					hierarchyLevel = ++(mmpkt->senderNodeHierarchyLevel);
					dbg("RadioFrequencySensorC", "HierarchyLevel = %hhu.\n", hierarchyLevel);
	
				}
			}
	
			if(!busy)
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
		//bool result = FALSE;
		
		//result = call Ack.wasAcked(&pkt);
		//dbg("RadioFrequencySensorC", "[RESULT] %hhu.\n", result);
			
		if (&pkt == msg) {
			busy = FALSE;
		}
	
	}
}