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

#endif
