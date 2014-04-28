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
		interface Timer<TMilli> as Timer;
	}
}

implementation{
	uint8_t hierarchyLevel = 0;
	bool firstMessage = TRUE, busy = FALSE;
	message_t pkt;
	uint8_t foodEaten = 0;
	uint16_t counter = 0;
	
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

			if(call Memory.hasMoteInformation(mmpkt->nodeID)) {
				if(call Memory.hasAdjacentNode(mmpkt->senderNodeId)) {
					if(call Memory.getAdjacentNodeHierarchyLevel(mmpkt->senderNodeId) > mmpkt->senderNodeHierarchyLevel) {
						call Memory.setAdjacentNodeHierarchyLevel(mmpkt->senderNodeId, mmpkt->senderNodeHierarchyLevel);
						call Memory.setAdjacentMoteInMoteInformation(mmpkt->nodeID, mmpkt->senderNodeId); 
					} 
				} else call Memory.addAdjacentNode(mmpkt->senderNodeId, mmpkt->senderNodeHierarchyLevel);
			} else call Memory.insertNewMoteInformation(mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->foodEaten, mmpkt->senderNodeId, mmpkt->senderNodeHierarchyLevel);

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
			call Timer.startPeriodic(TIMER_PERIOD_MILLI);
		}
		else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
		dbg("RadioFrequencySensorC", "RadioFrequencySensorC: packet sent.\n");	
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
	
	MoteInformationMessage* PrepareMoteInformationMessage(MoteInformation moteInformation) {
		MoteInformationMessage* mmpkt = (MoteInformationMessage*)(call Packet.getPayload(&pkt, sizeof (MoteInformationMessage)));
	
		mmpkt->nodeID = moteInformation.nodeID;
		mmpkt->foodEaten = moteInformation.foodEaten;
		mmpkt->x = moteInformation.x;
		mmpkt->y = moteInformation.y;
		mmpkt->senderNodeId = TOS_NODE_ID;
		mmpkt->senderNodeHierarchyLevel = hierarchyLevel;
		mmpkt->reply = 1;
		return mmpkt;
	}
	
	void SendMoteInformationToNode(MoteInformationMessage* moteInformationMessage, uint16_t nodeID) {
		if (call AMSend.send(nodeID, &pkt, sizeof(MoteInformationMessage)) == SUCCESS && call Ack.requestAck(&pkt) == SUCCESS) {
			busy = TRUE;
			firstMessage = FALSE;
		}
	}

	event void Timer.fired() {
		uint16_t i = 0, j = 0;
		MoteInformationMessage* informationToSend;
		nx_struct AdjacentMoteInformation adjacentMote;
		MoteInformation moteInformation;
		++counter;

		if(counter >= 15 && hierarchyLevel > 1) {
			dbg("RadioFrequencySensorC", "RadioFrequencySensorC: Timer fired, counter is %hu.\n", counter);
	
			for(i; i < call Memory.getNumberOfAdjacentNodes(); i++) {
				adjacentMote = call Memory.getAdjacentNodeInformation(i);
				for(j; j < call Memory.getNumberOfKnownNodes(); j++) {
					moteInformation = call Memory.getNodeInformation(j);
//				dbg("RadioFrequencySensorC", "****************************************************************\n");
//				dbg("RadioFrequencySensorC", "Is mote %hhu migrated? -> %hhu\n", moteInformation.nodeID, moteInformation.migrated);
//				if(moteInformation.migrated == 1) dbg("RadioFrequencySensorC", "Estou mesmo a 1!\n");
//				dbg("RadioFrequencySensorC", "****************************************************************\n");	
					if(adjacentMote.adjacentNodeHierarchyLevel < hierarchyLevel && (adjacentMote.adjacentNodeID != moteInformation.nodeID || adjacentMote.adjacentNodeID != moteInformation.adjacentNodeID) && moteInformation.migrated == 0) {
						dbg("RadioFrequencySensorC", "SENDING %hhu TO %hhu.\n", moteInformation.nodeID, adjacentMote.adjacentNodeID);
						informationToSend = PrepareMoteInformationMessage(moteInformation);
						SendMoteInformationToNode(informationToSend, adjacentMote.adjacentNodeID);	
					}
				}
			}	
	
			for(j = 0; j < call Memory.getNumberOfKnownNodes(); j++)
				call Memory.setInformationMigration(j, 1);
		}
	}
}