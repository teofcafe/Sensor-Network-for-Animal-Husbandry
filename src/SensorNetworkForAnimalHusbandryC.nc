#include <Timer.h>
#include "SensorNetworkForAnimalHusbandry.h"
 
module SensorNetworkForAnimalHusbandryC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Receive;
	uses interface PacketTimeStamp<TMilli, uint32_t> as TimeStamp0;
}

implementation {
	uint16_t counter = 0;
	bool firstMessage = TRUE, busy = FALSE;
	message_t pkt; 
	GPSCoordinate coordinate;
	uint16_t hierarchyLevel = 0;
	MoteInformation motesInformation[100]; 
	int motesInformationIndex = 0;
	int requestersNodeID[100];
	int requestersNodeIDIndex = 0;
	AdjacentMote adjacentMotes[100];
	int adjacentMotesIndex = 0;
	
	void SendBroadcastMessage() {
		MoteMessage* mmpkt = (MoteMessage*)(call Packet.getPayload(&pkt, sizeof (MoteMessage)));
	
		mmpkt->x = coordinate.x;
		mmpkt->y = coordinate.y;
		mmpkt->nodeID = TOS_NODE_ID;
		mmpkt->senderID = TOS_NODE_ID;
		mmpkt->counter = counter;
		mmpkt->reply = 0;
		mmpkt->senderHierarchyLevel = hierarchyLevel;
	
		dbg("SensorNetworkForAnimalHusbandryC", "Starting BROADCAST message...\n");
	
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoteMessage)) == SUCCESS) {
			dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: packet sent.\n");	
			busy = TRUE;
			firstMessage = FALSE;
		}
	}
	
	MoteMessage* PrepareMoteInformationMessage(MoteInformation moteInformation) {
		MoteMessage* mmpkt = (MoteMessage*)(call Packet.getPayload(&pkt, sizeof (MoteMessage)));
	
		mmpkt->nodeID = moteInformation.nodeID;
		mmpkt->x = moteInformation.x;
		mmpkt->y = moteInformation.y;
		mmpkt->reply = 1;
		mmpkt->senderID = TOS_NODE_ID;
		mmpkt->senderHierarchyLevel = hierarchyLevel;
		return mmpkt;
	}
	
	void SendMoteInformationToRequester(MoteMessage* mmpkt, nx_uint16_t requesterNodeId) {
	
		if (call AMSend.send(requesterNodeId, &pkt, sizeof(MoteMessage)) == SUCCESS) {
			dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: packet sent.\n");	
			busy = TRUE;
			firstMessage = FALSE;
		}
	
	}
	
	void insertNewMote(nx_struct MoteInformation newMote) {
		int i = 0;
		bool update = FALSE;
		MoteInformation moteInformation;
		
		for(i = 0; i < motesInformationIndex; i++) {
			moteInformation = motesInformation[i];	
				
			if(moteInformation.nodeID == newMote.nodeID) {
				if(moteInformation.migrated == 1)
					newMote.migrated = 1;
			
			motesInformation[i] = newMote;
			
			dbg("SensorNetworkForAnimalHusbandryC", "[MOTE-INFORMATION] UPDATED MOTE: %hhu.\n", newMote.nodeID);
			
			update = TRUE;	
			break;
			}
		}

		if(!update) {
			motesInformation[motesInformationIndex++] = newMote;
			dbg("SensorNetworkForAnimalHusbandryC", "[MOTE-INFORMATION] ADDED NEW MOTE: %hhu.\n", newMote.nodeID);
		}
	}
	
	void insertNewAdjacentMote(nx_struct AdjacentMote newAdjacentMote) {
		int i = 0;
		bool exist = FALSE;
	
		for(i = 0; i < adjacentMotesIndex; i++) 
			if(adjacentMotes[i].nodeID == newAdjacentMote.nodeID) {
			exist = TRUE;	
			break;
		}

		if(!exist) {
			adjacentMotes[adjacentMotesIndex++] = newAdjacentMote;			
			dbg("SensorNetworkForAnimalHusbandryC", "[MOTE-INFORMATION] ADDED NEW ADJACENT MOTE: %hhu.\n", newAdjacentMote.nodeID);
		}
	}

	event void Boot.booted() {
		dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: boot fired, counter is %hu.\n", counter);
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
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
 
	event void Timer0.fired() {
		int i = 0, j = 0;
		MoteMessage* informationToSend;
		AdjacentMote adjacentMote;
		MoteInformation moteInformation;
		counter++;
		dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: Timer fired, counter is %hu.\n", counter);
	
		if(counter % 10 == 1) {
			for(i; i < adjacentMotesIndex; i++) {
				adjacentMote = adjacentMotes[i];
				for(j; j < motesInformationIndex; j++) {
					moteInformation = motesInformation[j];
					dbg("SensorNetworkForAnimalHusbandryC", "adjacentMote.hierarchyLevel: %hhu | hierarchyLevel: %hhu.\n", adjacentMote.hierarchyLevel, hierarchyLevel);
					if(adjacentMote.hierarchyLevel <= hierarchyLevel && (adjacentMote.nodeID != moteInformation.nodeID || adjacentMote.nodeID != moteInformation.adjacentNodeID) && moteInformation.migrated == 0) {
						dbg("SensorNetworkForAnimalHusbandryC", "SENDING %hhu TO %hhu.\n", moteInformation.nodeID, adjacentMote.nodeID);
						informationToSend = PrepareMoteInformationMessage(moteInformation);
						SendMoteInformationToRequester(informationToSend, adjacentMote.nodeID);	
					}
				}
			}				
		}		
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		int i = 0;
		nx_struct MoteInformation newMote;
		nx_struct AdjacentMote newAdjacentMote;
	
		if(len == sizeof(GPSCoordinate)) {
			GPSCoordinate* GPSpkt = (GPSCoordinate*)payload;
	
			dbg("SensorNetworkForAnimalHusbandryC", "[GPS] Received coordinate (%hhu, %hhu).\n", GPSpkt->x, GPSpkt->y);

			coordinate.x = GPSpkt->x;
			coordinate.y = GPSpkt->y;

		}
	
		else if(len == sizeof(request_msg)) {
			dbg("SensorNetworkForAnimalHusbandryC", "[REQUEST-MESSAGE] Received request message.\n");
			
			hierarchyLevel = 1;
	
			if (!busy)
				if(firstMessage)
				SendBroadcastMessage();
		}

		else if (len == sizeof(MoteMessage)) {
			MoteMessage* mmpkt = (MoteMessage*)payload;
	
			dbg("SensorNetworkForAnimalHusbandryC", "[MOTE-MESSAGE] NODE %hhu IS ON (%hhu, %hhu) -> SENDED BY %hhu [%hhu].\n", mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->senderID, mmpkt->senderHierarchyLevel);
	
			newMote.x = mmpkt->x;
			newMote.y = mmpkt->y;
			newMote.nodeID = mmpkt->nodeID;
			newMote.adjacentNodeID = mmpkt->senderID;
			newMote.migrated = 0;
	
			insertNewMote(newMote);

			newAdjacentMote.hierarchyLevel = mmpkt->senderHierarchyLevel;
			newAdjacentMote.nodeID = mmpkt->senderID;			
	
			insertNewAdjacentMote(newAdjacentMote);
	
			if(mmpkt->reply == 0) {
				if(mmpkt->senderHierarchyLevel + 1 < hierarchyLevel || hierarchyLevel == 0) {
					hierarchyLevel = ++(mmpkt->senderHierarchyLevel);
					dbg("SensorNetworkForAnimalHusbandryC", "HierarchyLevel = %hhu.\n", hierarchyLevel);
				
				}
			}
	
			if(!busy)
				if(firstMessage)
				SendBroadcastMessage();
		}
	
		return msg;
	}

}
