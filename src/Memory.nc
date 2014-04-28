#include "Memory.h"

interface Memory{
	
	// MoteInformation
	command nx_uint16_t getCurrentFoodAmount(nx_uint16_t feedingSpotID); 
	command void insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint8_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel);
	command nx_int16_t getNumberOfKnownNodes();
	command MoteInformation getNodeInformation(nx_uint16_t nodeID);
	command bool hasMoteInformation(nx_uint16_t nodeID);
	
	// MoteInformation - UPDATES
	command void setCurrentFoodAmount(nx_uint16_t feedingSpotID, nx_uint8_t currentFoodAmount);
	command void setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y);
	command void setFoodEatenByMote(nx_uint16_t nodeID, nx_uint8_t foodEaten);
	command void setInformationMigration(nx_uint16_t nodeID, nx_uint16_t migrationValue);
	command void setAdjacentMoteInMoteInformation(nx_uint16_t nodeID, nx_uint16_t adjacentNodeID);
	
	// AdjacentMoteInformation
	command AdjacentMoteInformation getAdjacentNodeInformation(nx_uint16_t nodeID);
	command nx_uint8_t getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID);
	command nx_int16_t getNumberOfAdjacentNodes();
	command bool hasAdjacentNode(nx_uint16_t adjacentNodeID);
	command void addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	
	// AdjacentMoteInformation - UPDATES
	command void setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	
	
	command void setFoodEatenByMe();
	command nx_uint16_t getFoodEatenByMe();
	command nx_uint16_t getQuantityOfFoodThatICanEat();
	command void updateFeedingSpotAfterEat(nx_uint8_t feedingSpotID);
}