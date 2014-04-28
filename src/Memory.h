#ifndef MEMORY_H
#define MEMORY_H

typedef nx_struct MoteInformation {
	nx_uint8_t x;
	nx_uint8_t y;
	nx_int8_t foodEaten;
	nx_uint16_t adjacentNodeID;
} MoteInformation;

typedef nx_struct AdjacentMoteInformation {
	nx_uint16_t adjacentNodeID;
	nx_uint8_t adjacentNodeHierarchyLevel;
} AdjacentMoteInformation;

#endif /* MEMORY_H */
