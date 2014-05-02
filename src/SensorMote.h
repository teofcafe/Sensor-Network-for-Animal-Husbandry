#ifndef SENSORMOTE_H
#define SENSORMOTE_H

enum {
		AM_SENSORMOTE = 6,
	AM_REQUEST_MSG = 6,
	TIMER_PERIOD_MILLI = 250,
	AM_GPSCOORDINATEMESSAGE = 6,
	AM_FEEDINGSPOTMESSAGE = 6,
	AM_RFID_TEST_MESSAGE = 6,
	AM_UPDATEFOODQUANTITY = 6
};

typedef nx_struct GPSCoordinateMessage {
	nx_uint16_t x;
	nx_uint16_t y;
} GPSCoordinateMessage;

typedef nx_struct FeedingSpotMessage {
	nx_uint8_t feedingSpotID;
	nx_uint8_t foodAmount;
	nx_uint8_t type; // 0 get; 1 set
} FeedingSpotMessage;

typedef nx_struct request_msg {
	nx_uint16_t nodeID;
} request_msg;

typedef nx_struct UpdateFoodQuantity {
	nx_uint16_t nodeID;
	nx_uint32_t foodQuantity;
	nx_uint8_t extraPlayload; 
} UpdateFoodQuantity;

typedef nx_struct RFID_test_message {
} RFID_test_message;
 
#endif