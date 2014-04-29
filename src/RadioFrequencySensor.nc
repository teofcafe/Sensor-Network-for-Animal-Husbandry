interface RadioFrequencySensor{
	command void propagateUpdatesOfFeedingSpots (nx_uint8_t feedingSpotID, nx_uint16_t feedingSpotAmount, nx_uint16_t nodeID, nx_uint16_t quantityEated);
}