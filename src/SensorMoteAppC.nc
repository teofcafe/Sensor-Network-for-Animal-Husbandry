#include <Timer.h>
#include "SensorMote.h"
 
configuration SensorMoteAppC {
	
}

implementation {
	components MainC;
   	components SensorMoteC as SensorMote;
   	components GPSCoordinateSensorC as GPSCoordinateSensor;
   	components RadioFrequencySensorC as RadioFrequencySensor;
   	components MemoryC as Memory;
   	components new TimerMilliC() as Timer;
 	components ActiveMessageC;
  	components new AMSenderC(AM_REQUEST_MSG);
	components new AMReceiverC(AM_REQUEST_MSG);
	components RFIDSensorC as RFIDSensorC;

   	SensorMote.Boot -> MainC;
  	SensorMote.AMControl -> ActiveMessageC;
	
	GPSCoordinateSensor.Receive -> AMReceiverC;	
	
	RadioFrequencySensor.Timer -> Timer;
	RadioFrequencySensor.MyCoordinate -> GPSCoordinateSensor.GPSCoordinateSensor; 
	RadioFrequencySensor.Receive -> AMReceiverC;
	RadioFrequencySensor.Memory -> Memory.Memory;
	RadioFrequencySensor.AMSend -> AMSenderC;
  	RadioFrequencySensor.AMControl -> ActiveMessageC;
  	RadioFrequencySensor.Packet -> AMSenderC;
  	RadioFrequencySensor.AMPacket -> AMSenderC;
  	RadioFrequencySensor.Ack -> AMSenderC;

  	RFIDSensorC.Receive -> AMReceiverC;
  	RFIDSensorC.Memory ->Memory.Memory;
  	RFIDSensorC.RadioFrequencySensor -> RadioFrequencySensor.RadioFrequencySensor;
}
