#ifndef RADIO_FREQUENCY_SENSOR_H
#define RADIO_FREQUENCY_SENSOR_H

typedef nx_struct UpdateFeedingSpot {
	nx_uint8_t feedingSpotID;
	nx_uint16_t feedingSpotFoodAmount;
	nx_uint16_t nodeID;
	nx_uint16_t foodEaten;
} UpdateFeedingSpot;

typedef nx_struct UpdateNode {
	nx_uint16_t nodeID;
	nx_uint8_t x;
	nx_uint8_t y;
} UpdateNode;

#endif /* RADIO_FREQUENCY_SENSOR_H */
