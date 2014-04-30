#include "Memory.h"

interface Memory{
	
	// MoteInformation - Gets
	command nx_uint16_t getCurrentFoodAmount(nx_uint8_t feedingSpotID); 
	command nx_uint16_t getNumberOfKnownNodes();
	command MoteInformation getNodeInformation(nx_uint16_t nodeID);
	command bool hasMoteInformation(nx_uint16_t nodeID);
	command nx_uint16_t getAmountOfFoodEatenByNode(nx_uint16_t nodeID);
	
	// MoteInformation - Sets
	command void setCurrentFoodAmount(nx_uint8_t feedingSpotID, nx_uint16_t currentFoodAmount);
	command void setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y);
	command void setFoodEatenByMote(nx_uint16_t nodeID, nx_uint16_t foodEaten);
	command void insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint16_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel);
	
	// AdjacentMoteInformation - Gets
	command AdjacentMoteInformation getAdjacentNodeInformation(nx_uint16_t nodeID);
	command nx_uint8_t getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID);
	command nx_uint16_t getNumberOfAdjacentNodes();
	command bool hasAdjacentNode(nx_uint16_t adjacentNodeID);
	
	// AdjacentMoteInformation - Sets
	command void setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	command void addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	
	// FeedingSpot - Gets
	command nx_uint16_t getFoodEatenByMe();
	command nx_uint16_t getQuantityOfFoodThatICanEat();
	
	// FeedingSpot - Sets
	command void updateFeedingSpotAfterEat(nx_uint8_t feedingSpotID);
}