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
}

implementation {
	uint16_t counter = 0;
	bool busy = FALSE;
	message_t pkt; 

	event void Boot.booted() {
		dbg("BlinkToRadioC", "BlinkToRadioC: timer fired, counter is %hu.\n", counter);
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
		dbg("BlinkToRadioC", "BlinkToRadioC: timer fired, counter is %hu.\n", counter);
		call Leds.set(counter);
	
		if (!busy && TOS_NODE_ID == 1) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (BlinkToRadioMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
			dbg("BlinkToRadioC", "TOS_NODE_ID: %hhu.\n", TOS_NODE_ID);	
			btrpkt->counter = counter;
			if (call AMSend.send(TOS_NODE_ID + 1, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				dbg("BlinkToRadioC", "BlinkToRadioC: packet sent.\n", counter);	
				busy = TRUE;
			}
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {

		if (len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
			call Leds.set(btrpkt->counter);
			dbg("BlinkToRadioC", "Received packet of length %hhu and from %hhu.\n", len, btrpkt->nodeid);
		}
	
		if (!busy) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (BlinkToRadioMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
			dbg("BlinkToRadioC", "TOS_NODE_ID: %hhu.\n", TOS_NODE_ID);	
			btrpkt->counter = counter;
			if (call AMSend.send(TOS_NODE_ID + 1, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				dbg("BlinkToRadioC", "BlinkToRadioC: packet sent.\n", counter);	
				busy = TRUE;
			}
		}
	
		return msg;
	}
}
