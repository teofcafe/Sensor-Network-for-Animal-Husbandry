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
	nx_uint16_t nodeID;
	nx_uint16_t x;
	nx_uint16_t y;
	nx_uint16_t counter;
	nx_uint16_t reply;
	nx_uint16_t senderID;
	nx_uint16_t senderHierarchyLevel;
} MoteMessage;

typedef nx_struct MoteInformation {
	nx_uint16_t nodeID;
    nx_uint16_t x;
	nx_uint16_t y;
    nx_uint16_t adjacentNodeID;
    nx_uint8_t migrated;
} MoteInformation;

typedef nx_struct AdjacentMote {
	nx_uint16_t nodeID;
    nx_uint16_t hierarchyLevel;
} AdjacentMote;

typedef nx_struct request_msg {
} request_msg;

#endif
