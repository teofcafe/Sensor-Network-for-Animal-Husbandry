#ifndef SENSORNETWORKFORANIMALHUSBANDRY_H
#define SENSORNETWORKFORANIMALHUSBANDRY_H

enum {
		AM_SENSORNETWORKFORANIMALHUSBANDRY = 6,
	TIMER_PERIOD_MILLI = 250,
	AM_REQUEST_MSG = 6,
	AM_GPSCOORDINATE = 6
};

typedef nx_struct GPSCoordinate {
	nx_uint16_t x;
	nx_uint16_t y;
} GPSCoordinate;

typedef nx_struct MoteMessage {
	GPSCoordinate gpsCoordinate;
	nx_uint16_t nodeID;
	nx_uint16_t sender;
	nx_uint16_t timeStamp;
} MoteMessage;

typedef nx_struct KnownMotes {
	nx_uint16_t nodeID;
	GPSCoordinate gpsCoordinate;
} KnownMotes;

typedef nx_struct request_msg {
	nx_uint16_t counter;
} request_msg;

#endif
