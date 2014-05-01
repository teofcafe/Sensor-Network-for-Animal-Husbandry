#include "Memory.h"

module MemoryC{
	provides interface Memory;
}

implementation{
	nx_uint16_t feedingSpots[100];
	uint16_t quantityOfFoodThatICanEat = 50;
	nx_struct MoteInformation motesInformation[100];
	uint16_t motesInformationIndex = 0;
	nx_struct AdjacentMoteInformation adjacentNodesInformation[100];
	uint16_t adjacentNodesInformationIndex = 0;
	uint16_t foodEatenByMe = 0;
	
	command nx_uint16_t Memory.getCurrentFoodAmount(nx_uint8_t feedingSpotID){
		return feedingSpots[feedingSpotID];
	}

	command void Memory.setCurrentFoodAmount(nx_uint8_t feedingSpotID, nx_uint16_t currentFoodAmount){
		dbg("MemoryC", "[FeedingSpot] .::UPDATE::. Feeding spot %hhu with %hhu amount of food.\n", feedingSpotID, currentFoodAmount);
		feedingSpots[feedingSpotID] = currentFoodAmount;
	}
	
	command void Memory.addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel) {
		adjacentNodesInformation[adjacentNodesInformationIndex].nodeID = adjacentNodeID;
		adjacentNodesInformation[adjacentNodesInformationIndex++].hierarchyLevel = hierarchyLevel;
		dbg("MemoryC", "[AdjacentMoteInformation] .::NEW::. Adjacent mote %hhu [%hhu].\n", adjacentNodeID, hierarchyLevel);	
	}
	

	command void Memory.insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint16_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel){
		

		motesInformation[motesInformationIndex].nodeID = nodeID;
		motesInformation[motesInformationIndex].x = x;
		motesInformation[motesInformationIndex].y = y;
		motesInformation[motesInformationIndex++].foodEaten = foodEaten;
		dbg("MemoryC", "[MoteInformation] .::NEW::. Mote %hhu is at (%hhu, %hhu) and has eaten %hhu amount of food.\n", nodeID, x, y, foodEaten);	
		if(call Memory.hasAdjacentNode(adjacentNodeID) == TRUE) {
			if(call Memory.getAdjacentNodeHierarchyLevel(adjacentNodeID) > adjacentNodeHierarchyLevel) 
				call Memory.setAdjacentNodeHierarchyLevel(adjacentNodeID, adjacentNodeHierarchyLevel);
		} else call Memory.addAdjacentNode(adjacentNodeID, adjacentNodeHierarchyLevel);
	}

	command void Memory.setFoodEatenByMote(nx_uint16_t nodeID, nx_uint16_t foodEaten){
		uint16_t i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) {
			motesInformation[i].foodEaten = foodEaten;
			dbg("MemoryC", "[MoteInformation] .::UPDATE::. Mote %hhu has eaten %hhu amount of food.\n", motesInformation[i].nodeID, motesInformation[i].foodEaten);	
			break;
		}
	}

	command void Memory.setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y){
		uint16_t i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) {
				motesInformation[i].x = x;
				motesInformation[i].y = y;
				dbg("MemoryC", "[MoteInformation] .::UPDATE::. Mote %hhu is at (%hhu, %hhu).\n", motesInformation[i].nodeID, motesInformation[i].x, motesInformation[i].y);	
				break;
			}
	}

	command nx_uint16_t Memory.getNumberOfAdjacentNodes() {
		return adjacentNodesInformationIndex;
	}
	
	command nx_struct AdjacentMoteInformation Memory.getAdjacentNodeInformation(nx_uint16_t i) {
		return adjacentNodesInformation[i];
	}


	command nx_struct MoteInformation Memory.getNodeInformation(nx_uint16_t nodeID){
		uint16_t i;
		for(i = 0; i <= motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			return motesInformation[i];
		return motesInformation[i]; // This never happens
	}

	command nx_uint16_t Memory.getNumberOfKnownNodes(){
		return motesInformationIndex;
	}

	command bool Memory.hasMoteInformation(nx_uint16_t nodeID){
		uint16_t i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) 
			return TRUE;
		return FALSE;
	}

	command void Memory.setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel){
		uint16_t i;
		for(i = 0; i <= adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == adjacentNodeID) { 
			adjacentNodesInformation[i].hierarchyLevel = hierarchyLevel;
			dbg("MemoryC", "[AdjacentMoteInformation] .::UPDATE::. Adjacent mote %hhu [%hhu].\n", adjacentNodesInformation[i].nodeID, adjacentNodesInformation[i].hierarchyLevel);	
			break;
		}
	}

	command bool Memory.hasAdjacentNode(nx_uint16_t adjacentNodeID){
		uint16_t i;
		for(i = 0; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == adjacentNodeID) 
			return TRUE;
		return FALSE;
	}
	
	command nx_uint8_t Memory.getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID) {
		uint16_t i;
		for(i = 0; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == nodeID) 
			return adjacentNodesInformation[i].hierarchyLevel;
		return 0;
	}
	
	command nx_uint16_t Memory.getFoodEatenByMe(){
		return foodEatenByMe;	
	}
	
	command nx_uint16_t Memory.getQuantityOfFoodThatICanEat(){
		return quantityOfFoodThatICanEat;
	}
	
	command void Memory.setQuantityOfFoodThatICanEat(uint8_t quantity){
		quantityOfFoodThatICanEat = quantity;
		dbg("MemoryC", "[FeedingSpot] .::UPDATE::. I can eat %hhu amount of food.\n", quantityOfFoodThatICanEat);
	}
	
	command void Memory.updateFeedingSpotAfterEat(nx_uint8_t feedingSpotID){
		uint16_t eatedNow;
		eatedNow = min(quantityOfFoodThatICanEat, feedingSpots[feedingSpotID]);
		foodEatenByMe = foodEatenByMe + eatedNow;
		if(quantityOfFoodThatICanEat > feedingSpots[feedingSpotID])
			feedingSpots[feedingSpotID] =  0;
		else 
			feedingSpots[feedingSpotID] = feedingSpots[feedingSpotID] - quantityOfFoodThatICanEat;
	
		dbg("MemoryC", "[FeedingSpot] .::UPDATE::. Feeding spot %hhu has %hhu amount of food.\n", feedingSpotID, feedingSpots[feedingSpotID]);
		dbg("MemoryC", "[FeedingSpot] .::UPDATE::. I ate %hhu amount of food.\n", foodEatenByMe);
	}
	
	command nx_uint16_t Memory.getAmountOfFoodEatenByNode(nx_uint16_t nodeID) {
		uint16_t i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			return motesInformation[i].foodEaten;	
		return 0;
	}	
}