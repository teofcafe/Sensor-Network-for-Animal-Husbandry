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
	bool busy = FALSE;
	message_t pkt; 

	event void Boot.booted() {
		dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: timer fired, counter is %hu.\n", counter);
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
		call Leds.set(counter);
	
		if (!busy) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof (BlinkToRadioMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
			dbg("SensorNetworkForAnimalHusbandryC", "TOS_NODE_ID: %hhu.\n", TOS_NODE_ID);	
			btrpkt->counter = counter;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
				dbg("SensorNetworkForAnimalHusbandryC", "SensorNetworkForAnimalHusbandryC: packet sent.\n", counter);	
				busy = TRUE;
			}
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {

		if (len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
			call Leds.set(btrpkt->counter);
			dbg("SensorNetworkForAnimalHusbandryC", "Received packet of length %hhu and from %hhu.\n", len, btrpkt->nodeid);
		}
	
		return msg;
	}
}
