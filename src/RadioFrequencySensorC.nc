#include "SensorMote.h"
#include "Memory.h"
#include "RadioFrequencySensor.h"

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
	provides interface RadioFrequencySensor;
}

implementation{
	uint8_t hierarchyLevel = 0;
	bool firstMessage = TRUE, busy = FALSE;
	message_t pkt;
	uint16_t counter = 0;	
	uint32_t timeControl;
	uint16_t nodeRequested;
	
	void sendMoteInformationToNode(MoteInformationMessage* moteInformationMessage, uint16_t nodeID) {
		//TODO possivel bug
		dbg("RadioFrequencySensorC", "Sending %hhu to node %hhu.\n", moteInformationMessage->nodeID, nodeID);		
		call Ack.requestAck(&pkt);
		if (call AMSend.send(nodeID, &pkt, sizeof(MoteInformationMessage)) == SUCCESS && call Ack.requestAck(&pkt) == SUCCESS) {
			busy = TRUE;
			firstMessage = FALSE;
			timeControl = call Timer.getNow();
			dbg("RadioFrequencySensorC", "[1] TimeStamp: %hhu.\n", timeControl);
		}
	}
	
	MoteInformationMessage* prepareMoteInformationMessage(uint16_t moteID) {
		MoteInformationMessage* mmpkt = (MoteInformationMessage*)(call Packet.getPayload(&pkt, sizeof (MoteInformationMessage)));
		MoteInformation moteInformation;
	
		if(moteID != TOS_NODE_ID) {
			moteInformation = call Memory.getNodeInformation(moteID);
	
			mmpkt->nodeID = moteInformation.nodeID;
			mmpkt->foodEaten = moteInformation.foodEaten;
			mmpkt->x = moteInformation.x;
			mmpkt->y = moteInformation.y;
			mmpkt->requestedNode = moteInformation.nodeID;
		} else {
			mmpkt->nodeID = TOS_NODE_ID;
			mmpkt->foodEaten = call Memory.getFoodEatenByMe();
			mmpkt->x = call MyCoordinate.getCoordX();
			mmpkt->y = call MyCoordinate.getCoordY();
			mmpkt->requestedNode = TOS_NODE_ID;		
		}
	
		mmpkt->reply = 1;
	
		return mmpkt;
	}
	
	void SendBroadcastMessage() {
		MoteInformationMessage* mmpkt = (MoteInformationMessage*)(call Packet.getPayload(&pkt, sizeof (MoteInformationMessage)));
	
		mmpkt->x = call MyCoordinate.getCoordX();
		mmpkt->y = call MyCoordinate.getCoordY();
		mmpkt->nodeID = TOS_NODE_ID;
		mmpkt->foodEaten = call Memory.getFoodEatenByMe();
		mmpkt->senderNodeHierarchyLevel = hierarchyLevel; 
		mmpkt->requestedNode = nodeRequested;
		mmpkt->reply = 0;
	
		dbg("RadioFrequencySensorC", "Starting BROADCAST message...\n");
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoteInformationMessage)) == SUCCESS) {
			dbg("RadioFrequencySensorC", "Success BROADCAST message...\n");	
			busy = TRUE;
			firstMessage = FALSE;
		}				
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		MoteInformation moteInfo;
	
		if(len == sizeof(FeedingSpotMessage)) {
			FeedingSpotMessage* feedingSpotpkt = (FeedingSpotMessage*) payload;
			call Memory.setCurrentFoodAmount(feedingSpotpkt->feedingSpotID, feedingSpotpkt->foodAmount);
		}
	
		else if(len == sizeof(request_msg)) {
			request_msg* rpkt = (request_msg*)payload;
	
			dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE] Received request message.\n");
	
			if(rpkt->nodeID == TOS_NODE_ID) {
				dbg("RadioFrequencySensorC", "*********************************************************************\n");	
				dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE ANSWER] Node %hhu is on (%hhu, %hhu) and has eaten %hhu amount of food!\n", rpkt->nodeID, call MyCoordinate.getCoordX(), call MyCoordinate.getCoordY(), call Memory.getFoodEatenByMe());	
				dbg("RadioFrequencySensorC", "*********************************************************************\n");	
			} else if(call Memory.hasMoteInformation(rpkt->nodeID)) {
				moteInfo = call Memory.getNodeInformation(rpkt->nodeID);
				dbg("RadioFrequencySensorC", "*********************************************************************\n");	
				dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE ANSWER] Node %hhu is on (%hhu, %hhu) and has eaten %hhu amount of food!\n", moteInfo.nodeID, moteInfo.x, moteInfo.y, moteInfo.foodEaten);	
				dbg("RadioFrequencySensorC", "*********************************************************************\n");	
				return msg;
			}
			else {
	
				nodeRequested = rpkt->nodeID;	
			}
	
			hierarchyLevel = 1;
			if (!busy)
				if(firstMessage)
				SendBroadcastMessage();
	
	
		} else if (len == sizeof(MoteInformationMessage)) {
			uint16_t i;
			MoteInformationMessage* replyMessage;
			AdjacentMoteInformation adjacentMote;
			MoteInformationMessage* mmpkt = (MoteInformationMessage*)payload;
	
			dbg("RadioFrequencySensorC", "[MOTE-MESSAGE] Node %hhu is on (%hhu, %hhu) and has eaten %hhu amount of food -> reply: %hhu. -> sended by: %hhu\n", mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->foodEaten, mmpkt->reply, call AMPacket.source(msg));

			if(call Memory.hasMoteInformation(mmpkt->nodeID)) {
				if(call Memory.hasAdjacentNode(call AMPacket.source(msg))) {
					if(call Memory.getAdjacentNodeHierarchyLevel(call AMPacket.source(msg)) > mmpkt->senderNodeHierarchyLevel) {
						call Memory.setAdjacentNodeHierarchyLevel(call AMPacket.source(msg), mmpkt->senderNodeHierarchyLevel);
					} 
				} else call Memory.addAdjacentNode(call AMPacket.source(msg), mmpkt->senderNodeHierarchyLevel);
			} else call Memory.insertNewMoteInformation(mmpkt->nodeID, mmpkt->x, mmpkt->y, mmpkt->foodEaten, call AMPacket.source(msg), mmpkt->senderNodeHierarchyLevel);

			if(mmpkt->reply == 0) {
	
				if(mmpkt->senderNodeHierarchyLevel + 1 < hierarchyLevel || hierarchyLevel == 0) {
					hierarchyLevel = ++(mmpkt->senderNodeHierarchyLevel);
					dbg("RadioFrequencySensorC", "My Hierarchy Level: %hhu.\n", hierarchyLevel);
				}
	
				nodeRequested = mmpkt->requestedNode;
			}
	
			if(call Memory.hasMoteInformation(nodeRequested) || nodeRequested == TOS_NODE_ID) {
				if(hierarchyLevel == 1) {
					moteInfo = call Memory.getNodeInformation(mmpkt->requestedNode);
					dbg("RadioFrequencySensorC", "*********************************************************************\n");	
					dbg("RadioFrequencySensorC", "[REQUEST-MESSAGE ANSWER] Node %hhu is on (%hhu, %hhu) and has eaten %hhu amount of food!\n", moteInfo.nodeID, moteInfo.x, moteInfo.y, moteInfo.foodEaten);	
					dbg("RadioFrequencySensorC", "*********************************************************************\n");	
					return msg;
				} else {
					replyMessage = prepareMoteInformationMessage(mmpkt->requestedNode);
	
					for(i = 0; i < call Memory.getNumberOfAdjacentNodes(); i++) {
						adjacentMote = call Memory.getAdjacentNodeInformation(i);
						if(adjacentMote.hierarchyLevel < hierarchyLevel) {
							dbg("RadioFrequencySensorC", "\n\n[TESTE] %hhu [%hhu].\n\n", adjacentMote.nodeID, adjacentMote.hierarchyLevel);	
							sendMoteInformationToNode(replyMessage, adjacentMote.nodeID);
							return msg;
						}
					}
				}
			} else if(!busy)
				if(firstMessage) 
				SendBroadcastMessage();
		}
	
		else if (len == sizeof(UpdateFeedingSpot)) {
			UpdateFeedingSpot* mmpkt = (UpdateFeedingSpot*)payload;
	
			dbg("RadioFrequencySensorC", "[UpdateFeedingSpot] Has %hhu? : %hhu.\n", mmpkt->nodeID, call Memory.hasMoteInformation(mmpkt->nodeID));
			if(call Memory.hasMoteInformation(mmpkt->nodeID) && call Memory.getAmountOfFoodEatenByNode(mmpkt->nodeID) != mmpkt->foodEaten) {
				dbg("RadioFrequencySensorC", "[UpdateFeedingSpot] FS ID: %hhu | FS Amount: %hhu | NODE ID: %hhu | FoodEaten: %hhu.\n", mmpkt->feedingSpotID, mmpkt->feedingSpotFoodAmount, mmpkt->nodeID, mmpkt->foodEaten);
				if(call Memory.getAmountOfFoodEatenByNode(mmpkt->nodeID) != mmpkt->foodEaten) {
					call Memory.setFoodEatenByMote(mmpkt->nodeID, mmpkt->foodEaten);
					call Memory.setCurrentFoodAmount(mmpkt->feedingSpotID, mmpkt->feedingSpotFoodAmount);
					call RadioFrequencySensor.propagateUpdatesOfFeedingSpots(mmpkt->feedingSpotID, mmpkt->feedingSpotFoodAmount, mmpkt->nodeID, mmpkt->foodEaten);
				} 
			} else if(call Memory.getCurrentFoodAmount(mmpkt->feedingSpotID) != mmpkt->feedingSpotFoodAmount) {
				call Memory.setCurrentFoodAmount(mmpkt->feedingSpotID, mmpkt->feedingSpotFoodAmount);
				call RadioFrequencySensor.propagateUpdatesOfFeedingSpots(mmpkt->feedingSpotID, mmpkt->feedingSpotFoodAmount, mmpkt->nodeID, mmpkt->foodEaten);
			} else dbg("RadioFrequencySensorC", ".::[STOP]::.\n");
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

	event void AMControl.stopDone(error_t err) {}

	void sendUpdateOfFeedingSpot(UpdateFeedingSpot* updateMessage) {
		uint16_t i;
		nx_struct AdjacentMoteInformation adjacentMote;

		for(i = 0; i < call Memory.getNumberOfAdjacentNodes(); i++) {
			adjacentMote = call Memory.getAdjacentNodeInformation(i);	
			if(adjacentMote.nodeID != updateMessage->nodeID) {
				if (call AMSend.send(adjacentMote.nodeID, &pkt, sizeof(UpdateFeedingSpot)) == SUCCESS && call Ack.requestAck(&pkt) == SUCCESS) {
					dbg("RadioFrequencySensorC", "[1] TimeStamp: %hhu.\n", timeControl);
					busy = TRUE;
					firstMessage = FALSE;
				}
			}
		}
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {	
	
		if (&pkt == msg) {
			if(call Ack.wasAcked(&pkt) == TRUE) {
				dbg("RadioFrequencySensorC", "[2] TimeStamp: %hhu.\n", call Timer.getNow());
				dbg("RadioFrequencySensorC", "RadioFrequencySensorC: Packet sent.\n");			
				busy = FALSE;
			} else if(call Timer.getNow() > timeControl + 10) {
				dbg("RadioFrequencySensorC", "[3] TimeStamp: %hhu.\n", call Timer.getNow());
				dbg("RadioFrequencySensorC", "RadioFrequencySensorC: Packet resent.\n");	
				if(call Packet.payloadLength(msg) == sizeof(MoteInformationMessage))
					sendMoteInformationToNode(call Packet.getPayload(msg, call Packet.payloadLength(msg)), call AMPacket.destination(msg));
				else if(call Packet.payloadLength(msg) == sizeof(UpdateFeedingSpot)) 
					sendUpdateOfFeedingSpot(call Packet.getPayload(msg, call Packet.payloadLength(msg)));
			}
		}
	}
	
	event void Timer.fired() {
		counter++;
		//dbg("RadioFrequencySensorC", "RadioFrequencySensorC: Timer fired, counter is %hu.\n", counter);		
	}

	command void RadioFrequencySensor.propagateUpdatesOfFeedingSpots(nx_uint8_t feedingSpotID, nx_uint16_t feedingSpotAmount, nx_uint16_t nodeID, nx_uint16_t quantityEated) {
		UpdateFeedingSpot* ufspkt = (UpdateFeedingSpot*)(call Packet.getPayload(&pkt, sizeof (UpdateFeedingSpot)));
		dbg("RadioFrequencySensorC", "[FEEDING SPOT PREPARE] Preparing update to send...\n");
	
		ufspkt->feedingSpotID = feedingSpotID;
		ufspkt->feedingSpotFoodAmount = feedingSpotAmount;
		ufspkt->nodeID = nodeID;
		ufspkt->foodEaten = quantityEated;
		dbg("RadioFrequencySensorC", "[VERIFY] %hhu %hhu %hhu %hhu\n", feedingSpotID, feedingSpotAmount, nodeID, quantityEated);
	
		sendUpdateOfFeedingSpot(ufspkt);
	}
}