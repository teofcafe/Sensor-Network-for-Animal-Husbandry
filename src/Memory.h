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




 /*As funcoes min e max no codigo abaixo servem como auxiliares ao controlo da quantidade de comida ingerida
  * por cada animal, isto e, sao usadas para saber que comida resta no feeding spot apos o rfid do animal ter
  * sido detectado e a comida ter sido facultada. Assim, caso o animal queira tenha uma quantidade de comida
  * que deve ser ingerida superior ao que resta no feeding spot, as funcoes min e max retornam a quantidade que
  * resta no feeding spot em questao ( que vai ser zero) e o que o animal comeu, que vai ser a quantidade que o
  * feeding spot tinha como restante antes de ficr vazio.
  */
 
uint16_t min(uint16_t a, uint16_t b){
	return (a < b) ? a : b;
}
	
uint16_t max(uint16_t a, uint16_t b){
	return (a > b) ? a : b;
}

#endif /* MEMORY_H */
