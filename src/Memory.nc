interface Memory{
	command void setCurrentFoodAmount(nx_uint16_t feedingSpotID, nx_uint8_t currentFoodAmount);
	command nx_uint16_t getCurrentFoodAmount(nx_uint16_t feedingSpotID); 
	command void setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y);
	command void setFoodEatenByMote(nx_uint16_t nodeID, nx_uint8_t foodEaten);
	command void insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint8_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel);
	command nx_uint16_t getFoodEatenByMe();
	command nx_uint16_t getQuantityOfFoodThatICanEat();
	command void setFoodEatenByMe();
	command void updateFeedingSpotAfterEat(nx_uint16_t feedingSpotID, nx_uint16_t quantity);
}