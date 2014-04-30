#include "Memory.h"

module MemoryC{
	provides interface Memory;
}

implementation{
	nx_uint16_t feedingSpots[100];
	uint16_t quantityOfFoodThatICanEat = 50;
	nx_struct MoteInformation motesInformation[10000];
	uint16_t motesInformationIndex = 0;
	nx_struct AdjacentMoteInformation adjacentNodesInformation[100];
	uint16_t adjacentNodesInformationIndex = 0;
	uint16_t foodEatenByMe = 0;
	
	command nx_uint16_t Memory.getCurrentFoodAmount(nx_uint8_t feedingSpotID){
		return feedingSpots[feedingSpotID];
	}

	command void Memory.setCurrentFoodAmount(nx_uint8_t feedingSpotID, nx_uint16_t currentFoodAmount){
		dbg("MemoryC", "[FeedingSpot] Received FeedingSpot %hhu with %hhu amount of food.\n", feedingSpotID, currentFoodAmount);
		feedingSpots[feedingSpotID] = currentFoodAmount;
	}
	
	command void Memory.addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel) {
		adjacentNodesInformation[adjacentNodesInformationIndex].nodeID = adjacentNodeID;
		adjacentNodesInformation[adjacentNodesInformationIndex++].hierarchyLevel = hierarchyLevel;
		dbg("MemoryC", "[AdjacentMoteInformation] Received Adjacent Mote with ID %hhu with %hhu hierarchy level.\n", adjacentNodeID, hierarchyLevel);	
	}
	

	command void Memory.insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint16_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel){

		motesInformation[motesInformationIndex].nodeID = nodeID;
		motesInformation[motesInformationIndex].x = x;
		motesInformation[motesInformationIndex].y = y;
		motesInformation[motesInformationIndex].foodEaten = foodEaten;
		motesInformation[motesInformationIndex].adjacentNodeID = adjacentNodeID;
		motesInformation[motesInformationIndex++].migrated = 0;
		dbg("MemoryC", "[MoteInformation] Received Mote with ID %hhu, in (%hhu, %hhu) and has eaten %hhu.\n", nodeID, x, y, foodEaten);	
		if(call Memory.hasAdjacentNode(adjacentNodeID) == TRUE) {
			if(call Memory.getAdjacentNodeHierarchyLevel(adjacentNodeID) > adjacentNodeHierarchyLevel) 
				call Memory.setAdjacentNodeHierarchyLevel(adjacentNodeID, adjacentNodeHierarchyLevel);
		} else call Memory.addAdjacentNode(adjacentNodeID, adjacentNodeHierarchyLevel);
	}

	command void Memory.setFoodEatenByMote(nx_uint16_t nodeID, nx_uint16_t foodEaten){
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			motesInformation[i].foodEaten = foodEaten;
	}

	command void Memory.setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y){
		// TODO Auto-generated method stub
	}

	command nx_uint16_t Memory.getNumberOfAdjacentNodes() {
		return adjacentNodesInformationIndex;
	}
	
	command nx_struct AdjacentMoteInformation Memory.getAdjacentNodeInformation(nx_uint16_t nodeID) {
		return adjacentNodesInformation[nodeID];
	}


	command nx_struct MoteInformation Memory.getNodeInformation(nx_uint16_t nodeID){
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
				return motesInformation[i];
		return motesInformation[i]; // This never happens
	}

	command nx_uint16_t Memory.getNumberOfKnownNodes(){
		return motesInformationIndex;
	}
	
	command void Memory.setInformationMigration(nx_uint16_t nodeID, nx_uint16_t migrationValue) {
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) {
			motesInformation[i].migrated = migrationValue;
			break;
		}
	}

	command bool Memory.hasMoteInformation(nx_uint16_t nodeID){
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) 
			return TRUE;
		return FALSE;
	}

	command void Memory.setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel){
		int i;
		for(i = 0; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == adjacentNodeID) 
			adjacentNodesInformation[i].hierarchyLevel = hierarchyLevel;
	}

	command bool Memory.hasAdjacentNode(nx_uint16_t adjacentNodeID){
		int i;
		for(i = 0; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == adjacentNodeID) 
			return TRUE;
		return FALSE;
	}
	
	command nx_uint8_t Memory.getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID) {
		int i;
		for(i = 0; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].nodeID == nodeID) 
			return adjacentNodesInformation[i].hierarchyLevel;
		return 0;
	}
	
	command void Memory.setAdjacentMoteInMoteInformation(nx_uint16_t nodeID, nx_uint16_t adjacentNodeID) {
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			(motesInformation[i].adjacentNodeID = adjacentNodeID);					
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
	
	command void Memory.updateFeedingSpotAfterEat(nx_uint8_t feedingSpotID){
		uint16_t eatedNow;
		eatedNow = min(quantityOfFoodThatICanEat, feedingSpots[feedingSpotID]);
		foodEatenByMe = foodEatenByMe + eatedNow;
		if(quantityOfFoodThatICanEat > feedingSpots[feedingSpotID])
			feedingSpots[feedingSpotID] =  0;
			else 
			feedingSpots[feedingSpotID] = feedingSpots[feedingSpotID] - quantityOfFoodThatICanEat;
	}
	
	command nx_uint16_t Memory.getAmountOfFoodEatenByNode(nx_uint16_t nodeID) {
		int i;
		for(i = 0; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			return motesInformation[i].foodEaten;	
		return 0;
	}
	
}
