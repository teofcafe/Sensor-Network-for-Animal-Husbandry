#include "Memory.h"

module MemoryC{
	provides interface Memory;
}

implementation{
	nx_uint8_t feedingSpots[100];
	nx_struct MoteInformation motesInformation[10000];
	uint16_t motesInformationIndex = 0;
	nx_struct AdjacentMoteInformation adjacentNodesInformation[100];
	uint16_t adjacentNodesInformationIndex = 0;
	
	command nx_uint8_t Memory.getCurrentFoodAmount(nx_uint16_t feedingSpotID){
		return feedingSpots[feedingSpotID];
	}

	command void Memory.setCurrentFoodAmount(nx_uint16_t feedingSpotID, nx_uint8_t currentFoodAmount){
		dbg("MemoryC", "[FeedingSpot] Received FeedingSpot %hhu with %hhu amount of food.\n", feedingSpotID, currentFoodAmount);
		feedingSpots[feedingSpotID] = currentFoodAmount;
	}
	
	command void Memory.addAdjacentNode(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel) {
		adjacentNodesInformation[adjacentNodesInformationIndex].adjacentNodeID = adjacentNodeID;
		adjacentNodesInformation[adjacentNodesInformationIndex++].adjacentNodeHierarchyLevel = hierarchyLevel;
		dbg("MemoryC", "[AdjacentMoteInformation] Received Adjacent Mote with ID %hhu with %hhu hierarchy level.\n", adjacentNodeID, hierarchyLevel);	
	}
	

	command void Memory.insertNewMoteInformation(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y, nx_uint8_t foodEaten, nx_uint16_t adjacentNodeID, nx_uint8_t adjacentNodeHierarchyLevel){
		motesInformation[motesInformationIndex].nodeID = nodeID;
		motesInformation[motesInformationIndex].x = x;
		motesInformation[motesInformationIndex].y = y;
		motesInformation[motesInformationIndex].foodEaten = foodEaten;
		motesInformation[motesInformationIndex].adjacentNodeID = adjacentNodeID;
		motesInformation[motesInformationIndex++].migrated = 0;
		dbg("MemoryC", "[MoteInformation] Received Mote with ID %hhu, in (%hhu, %hhu) and has eaten %hhu.\n", nodeID, x, y, foodEaten);	
		//TODO falta verificar se já temos aquele mote como adjacente antes de adicionar
		call Memory.addAdjacentNode(adjacentNodeID, adjacentNodeHierarchyLevel);
	}

	command void Memory.setFoodEatenByMote(nx_uint16_t nodeID, nx_uint8_t foodEaten){
		// TODO Auto-generated method stub
	}

	command void Memory.setMoteCoordinate(nx_uint16_t nodeID, nx_uint8_t x, nx_uint8_t y){
		// TODO Auto-generated method stub
	}

	command nx_int16_t Memory.getNumberOfAdjacentNodes(){
		return adjacentNodesInformationIndex;
	}
	
	command nx_struct AdjacentMoteInformation Memory.getAdjacentNodeInformation(nx_uint16_t nodeID) {
		return adjacentNodesInformation[nodeID];
	}


	command nx_struct MoteInformation Memory.getNodeInformation(nx_uint16_t nodeID){
		return motesInformation[nodeID];
	}

	command nx_int16_t Memory.getNumberOfKnownNodes(){
		return motesInformationIndex;
	}
	
	command void Memory.setInformationMigration(nx_uint16_t nodeID, nx_uint16_t migrationValue) {
		int i = 0;
		for(i; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) {
			motesInformation[i].migrated = migrationValue;
			break;
		}
	}

	command bool Memory.hasMoteInformation(nx_uint16_t nodeID){
		int i = 0;
		for(i; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID) 
			return TRUE;
		return FALSE;
	}

	command void Memory.setAdjacentNodeHierarchyLevel(nx_uint16_t adjacentNodeID, nx_uint8_t hierarchyLevel){
		int i = 0;
		for(i; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].adjacentNodeID == adjacentNodeID) 
			adjacentNodesInformation[i].adjacentNodeHierarchyLevel = hierarchyLevel;
	}

	command bool Memory.hasAdjacentNode(nx_uint16_t adjacentNodeID){
		int i = 0;
		for(i; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].adjacentNodeID == adjacentNodeID) 
			return TRUE;
		return FALSE;
	}
	
	command nx_uint8_t Memory.getAdjacentNodeHierarchyLevel(nx_uint16_t nodeID) {
		int i = 0;
		for(i; i < adjacentNodesInformationIndex; i++) 
			if(adjacentNodesInformation[i].adjacentNodeID == nodeID) 
			return adjacentNodesInformation[i].adjacentNodeHierarchyLevel;
		return 0;
	}
	
	command void Memory.setAdjacentMoteInMoteInformation(nx_uint16_t nodeID, nx_uint16_t adjacentNodeID) {
		int i = 0;
		for(i; i < motesInformationIndex; i++) 
			if(motesInformation[i].nodeID == nodeID)
			(motesInformation[i].adjacentNodeID = adjacentNodeID);					
	}
}
