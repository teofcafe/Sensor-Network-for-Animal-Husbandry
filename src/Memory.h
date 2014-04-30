#ifndef MEMORY_H
#define MEMORY_H

typedef nx_struct MoteInformation {
	nx_uint16_t nodeID;
	nx_uint8_t x;
	nx_uint8_t y;
	nx_int16_t foodEaten;
} MoteInformation;

typedef nx_struct AdjacentMoteInformation {
	nx_uint16_t nodeID;
	nx_uint8_t hierarchyLevel;
} AdjacentMoteInformation;
 
uint16_t min(uint16_t a, uint16_t b) {
	return (a < b) ? a : b;
}

#endif /* MEMORY_H */
