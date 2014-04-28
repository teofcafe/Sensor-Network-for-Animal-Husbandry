#include "Memory.h"

module MemoryC{
	provides interface Memory;
}
implementation{
	nx_uint16_t feedingSpots[100];
	uint16_t quantityOfFoodThatICanEat = 0;
	nx_struct MoteInformation motesInformation[10000];
	nx_struct AdjacentMoteInformation adjacentNodesInformation[100];
	int adjacentNodesInformationIndex = 0;
	uint16_t foodEatenByMe= 0;
	
	command nx_uint16_t Memory.getCurrentFoodAmount(nx_uint16_t feedingSpotID){
		return feedingSpots[feedingSpotID];
	}

	command void Memory.setCurrentFoodAmount(nx_uint16_t feedingSpotID, nx_uint8_t currentFoodAmount){
		dbg("MemoryC", "[FeedingSpot] Received FeedingSpot %hhu with %hhu amount of food.\n", feedingSpotID, currentFoodAmount);
		feedingSpots[feedingSpotID] = currentFoodAmount;
	}
	

	command void Memory.insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint8_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel){
		int i = 0; bool exist = FALSE;
		motesInformation[nodeID].x = x;
		motesInformation[nodeID].y = y;
		motesInformation[nodeID].foodEaten = foodEaten;
		motesInformation[nodeID].adjacentNodeID = adjacentNodeID;
		dbg("MemoryC", "[MoteInformation] Received Mote with ID %hhu, in (%hhu, %hhu) and has eaten %hhu.\n", nodeID, x, y, foodEaten);	
		
		//TO DO 
		
		adjacentNodesInformation[adjacentNodesInformationIndex].adjacentNodeID = adjacentNodeID;
		adjacentNodesInformation[adjacentNodesInformationIndex++].adjacentNodeHierarchyLevel = adjacentNodeHierarchyLevel;
		dbg("MemoryC", "[AdjacentMoteInformation] Received Adjacent Mote with ID %hhu with %hhu hierarchy level.\n", adjacentNodeID, adjacentNodeHierarchyLevel);	
	}

	command void Memory.setFoodEatenByMote(nx_uint16_t nodeID, nx_uint8_t foodEaten){
		// TODO Auto-generated method stub
	}

	command void Memory.setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y){
		// TODO Auto-generated method stub
	}
	
	command nx_uint16_t Memory.getFoodEatenByMe(){
		return foodEatenByMe;	
	}
	
	command void Memory.setFoodEatenByMe(){
		foodEatenByMe+=	foodEatenByMe;
	}
	
	command nx_uint16_t Memory.getQuantityOfFoodThatICanEat(){
		return quantityOfFoodThatICanEat;
	}
	
	command void Memory.updateFeedingSpotAfterEat(nx_uint16_t feedingSpotID, nx_uint16_t quantity){
		uint16_t eatedNow = min(quantityOfFoodThatICanEat, feedingSpots[feedingSpotID]);
		foodEatenByMe = foodEatenByMe + eatedNow;
		feedingSpots[feedingSpotID] =  max((feedingSpots[feedingSpotID] - quantityOfFoodThatICanEat), 0);
	    //TO DO Evento no RadioFrequency que expanda as mudancas aos outros nodes;	
	}
	
}
