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
	uses interface Queue<KnownMotes>;
	uses interface PacketTimeStamp<TMilli, uint32_t> as TimeStamp0;
}

implementation {
	uint16_t counter = 0;
	bool firstMessage = TRUE;
	bool busy = FALSE;
	message_t pkt; 
	
	void SendBroadcastMessage() {

		MoteMessage* mmpkt = (MoteMessage*)(call Packet.getPayload(&pkt, sizeof (MoteMessage)));
		//mmpkt->nodeID = TOS_NODE_ID;
		//mmpkt->counter = counter;
	
		if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoteMessage)) == SUCCESS) {
	
			//dbg("SensorNetworkForAnimalHusbandryC", "TOS_NODE_ID: %hhu | TimeStamp: %hhu.\n", TOS_NODE_ID, mmpkt->timeStamp);	
			dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: packet sent.\n");	
			busy = TRUE;
			firstMessage = FALSE;
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
		counter++;
		dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: timer fired, counter is %hu.\n", counter);
		//call Leds.set(counter);	
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {

		if(len == sizeof(request_msg)) {
			//call Leds.set(btrpkt->counter);
			request_msg* rpkt = (request_msg*)payload;
	
			dbg("SensorNetworkForAnimalHusbandryC", "[REQUEST-MESSAGE] Received request message of length %hhu with counter %hhu.\n", len, rpkt->counter);
			dbg("SensorNetworkForAnimalHusbandryC", "BUSY: %hhu | FIRSTMESSAGE: %hhu.\n", busy, firstMessage);
	
	
			if (!busy)
				if(firstMessage)
				SendBroadcastMessage();
	
			return msg;
		}

		else if (len == sizeof(MoteMessage)) {
			MoteMessage* mmpkt = (MoteMessage*)payload;
			//call Leds.set(btrpkt->counter);
			dbg("SensorNetworkForAnimalHusbandryC", "[MOTE-MESSAGE] Received packet of length %hhu, from %hhu with timeStamp %hhu.\n", len, mmpkt->nodeID, mmpkt->timeStamp);
	
	
			if (!busy)
				if(firstMessage)
				SendBroadcastMessage();
			return msg;
		}
	}

}
