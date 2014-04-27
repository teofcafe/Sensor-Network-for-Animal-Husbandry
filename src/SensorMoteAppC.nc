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
  	//components new AMSenderC(AM_REQUEST_MSG);
	components new AMReceiverC(AM_REQUEST_MSG);

   	SensorMote.Boot -> MainC;
   	SensorMote.Timer -> Timer;
  	SensorMote.AMControl -> ActiveMessageC;
	
	GPSCoordinateSensor.Receive -> AMReceiverC;	
	
	RadioFrequencySensor.MyCoordinate -> GPSCoordinateSensor.GPSCoordinateSensor; 
	RadioFrequencySensor.Receive -> AMReceiverC;
	RadioFrequencySensor.Memory -> Memory.Memory;
}
