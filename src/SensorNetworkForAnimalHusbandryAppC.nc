#include <Timer.h>
#include "SensorNetworkForAnimalHusbandry.h"
 
configuration SensorNetworkForAnimalHusbandryAppC {
	
}

implementation {
	components MainC;
   	//components LedsC;
   	components SensorNetworkForAnimalHusbandryC as App;
   	components new TimerMilliC() as Timer0;
 	components ActiveMessageC;
  	components new AMSenderC(AM_REQUEST_MSG);
	components new AMReceiverC(AM_REQUEST_MSG);
//	components new AMSenderC(AM_REQUEST_MSG)as AMSenderC0;
//  	components new AMReceiverC(AM_REQUEST_MSG)as AMReceiverC0;

   	App.Boot -> MainC;
   	App.Timer0 -> Timer0;
	App.Packet -> AMSenderC;
  	App.AMPacket -> AMSenderC;
  	App.AMSend -> AMSenderC;
  	App.AMControl -> ActiveMessageC;
	App.Receive -> AMReceiverC;
	
}
