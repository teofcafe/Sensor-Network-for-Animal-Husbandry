#include <Timer.h>
#include "SensorMote.h"
 
configuration SensorMoteAppC {}

implementation {
	components MainC;
   	components GPSCoordinateSensorC as GPSCoordinateSensor;
   	components RadioFrequencySensorC as RadioFrequencySensor;
   	components MemoryC as Memory;
   	components new TimerMilliC() as Timer;
 	components ActiveMessageC;
  	components new AMSenderC(AM_REQUEST_MSG);
	components new AMReceiverC(AM_REQUEST_MSG);
	components RFIDSensorC as RFIDSensorC;
	components RandomC;
	
	GPSCoordinateSensor.Receive -> AMReceiverC;	
	
	RadioFrequencySensor.Boot -> MainC;
  	RadioFrequencySensor.AMControl -> ActiveMessageC;
	RadioFrequencySensor.Timer -> Timer;
	RadioFrequencySensor.MyCoordinate -> GPSCoordinateSensor.GPSCoordinateSensor; 
	RadioFrequencySensor.Memory -> Memory.Memory;
	RadioFrequencySensor.AMSend -> AMSenderC;
  	RadioFrequencySensor.Packet -> AMSenderC;
  	RadioFrequencySensor.AMPacket -> AMSenderC;
  	RadioFrequencySensor.Ack -> AMSenderC;
  	RadioFrequencySensor.Receive -> AMReceiverC;
  	RadioFrequencySensor.AMControl -> ActiveMessageC;

  	RFIDSensorC.Receive -> AMReceiverC;
  	RFIDSensorC.Memory -> Memory.Memory;
  	RFIDSensorC.RadioFrequencySensor -> RadioFrequencySensor.RadioFrequencySensor;
  	RFIDSensorC.Random -> RandomC;
}
