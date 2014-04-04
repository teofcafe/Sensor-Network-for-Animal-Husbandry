#ifndef SENSORNETWORKFORANIMALHUSBANDRY_H
#define SENSORNETWORKFORANIMALHUSBANDRY_H

enum {
	AM_SENSORNETWORKFORANIMALHUSBANDRY = 6,
  	TIMER_PERIOD_MILLI = 250
};

typedef nx_struct BlinkToRadioMsg {
  	nx_uint16_t nodeid;
  	nx_uint16_t counter;
} BlinkToRadioMsg;

typedef nx_struct GPSCoordinate {
	nx_uint16_t x;
	nx_uint16_t y;
} GPSCoordinate;

typedef nx_struct MoteMsg {
  	GPSCoordinate gpsCoordinate;
  	nx_uint16_t nodeID;
  	nx_uint16_t timeStamp;
} MoteMsg;

#endif
