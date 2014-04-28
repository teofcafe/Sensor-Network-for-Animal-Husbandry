#ifndef SENSORMOTE_H
#define SENSORMOTE_H

enum {
		AM_SENSORMOTE = 6,
	AM_REQUEST_MSG = 6,
	TIMER_PERIOD_MILLI = 250,
	AM_GPSCOORDINATEMESSAGE = 6,
	AM_FEEDINGSPOTMESSAGE = 6
};

typedef nx_struct GPSCoordinateMessage {
	nx_uint8_t x;
	nx_uint8_t y;
} GPSCoordinateMessage;

typedef nx_struct FeedingSpotMessage {
	nx_uint16_t feedingSpotID;
	nx_uint8_t foodAmount;
} FeedingSpotMessage;

typedef nx_struct request_msg {
} request_msg;

typedef nx_struct MoteInformationMessage {
	nx_uint8_t nodeID;
	nx_uint8_t foodEaten;
	nx_uint8_t x;
	nx_uint8_t y;
	nx_uint8_t senderNodeId;
	nx_uint8_t senderNodeHierarchyLevel;
} MoteInformationMessage;

#endif
