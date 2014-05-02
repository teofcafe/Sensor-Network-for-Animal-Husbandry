#include "Memory.h"

interface Memory{
	// MoteInformation - Gets
	command nx_uint16_t getCurrentFoodAmount(nx_uint8_t feedingSpotID); 
	command nx_uint16_t getAmountOfFoodEatenByNode(nx_uint16_t nodeID);
	command nx_uint8_t getNodeCoordinateX(uint16_t nodeID);
	command nx_uint8_t getNodeCoordinateY(uint16_t nodeID);
	command MoteInformation getNodeInformation(nx_uint16_t nodeID);
	command bool hasMoteInformation(nx_uint16_t nodeID);
	command nx_uint16_t getNumberOfKnownNodes();
		
	// MoteInformation - Sets
	command void insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint16_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel);
	command void setCurrentFoodAmount(nx_uint8_t feedingSpotID, nx_uint16_t currentFoodAmount);
	command void setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y);
	command void setFoodEatenByMote(nx_uint16_t nodeID, nx_uint16_t foodEaten);
	
	// AdjacentMoteInformation - Gets
	command AdjacentMoteInformation getAdjacentNodeInformation(nx_uint16_t i);
	command nx_uint8_t getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID);
	command bool hasAdjacentNode(nx_uint16_t adjacentNodeID);
	command nx_uint16_t getNumberOfAdjacentNodes();
	
	// AdjacentMoteInformation - Sets
	command void setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	command void addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel);
	
	// FeedingSpot - Gets
	command nx_uint16_t getQuantityOfFoodThatICanEat();
	command nx_uint16_t getFoodEatenByMe();
	
	// FeedingSpot - Sets
	command void setQuantityOfFoodThatICanEat(uint8_t quantity);
	command void updateFeedingSpotAfterEat(nx_uint8_t feedingSpotID);
}