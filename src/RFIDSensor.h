#ifndef RFID_SENSOR_H
#define RFID_SENSOR_H

typedef nx_struct RFID_TEST_MESSAGE {
	nx_uint16_t feedingSpot;
	nx_uint8_t quantityToEat;
} RFID_test_message;

/* [RFID_TEST_MESSAGE] -> Esta estrutura de mensagem e apenas de teste, ou seja, este modulo nao vai receber
 * mensagens de nenhuma entidade em funcionamento real, vai apenas ser detectado pela
 * infraestrutura do FeedingSpot. Deste modo, a interface Receive deste modulo
 * tem apenas como fim servir de ponto de comunicacao entre o script e o modulo RFID,
 * para fazer testes;
 */
 

#endif
