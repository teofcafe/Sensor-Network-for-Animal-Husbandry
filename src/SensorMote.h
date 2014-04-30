#ifndef SENSORMOTE_H
#define SENSORMOTE_H

enum {
		AM_SENSORMOTE = 6,
	AM_REQUEST_MSG = 6,
	TIMER_PERIOD_MILLI = 250,
	AM_GPSCOORDINATEMESSAGE = 6,
	AM_FEEDINGSPOTMESSAGE = 6,
	AM_RFID_TEST_MESSAGE = 6
};

typedef nx_struct GPSCoordinateMessage {
	nx_uint16_t x;
	nx_uint16_t y;
} GPSCoordinateMessage;

typedef nx_struct FeedingSpotMessage {
	nx_uint8_t feedingSpotID;
	nx_uint16_t foodAmount;
} FeedingSpotMessage;

typedef nx_struct request_msg {
	nx_uint16_t nodeID;
} request_msg;

typedef nx_struct RFID_test_message {
	nx_uint8_t feedingSpot;
} RFID_test_message;

/* [RFID_TEST_MESSAGE] -> Esta estrutura de mensagem e apenas de teste, ou seja, este modulo nao vai receber
 * mensagens de nenhuma entidade em funcionamento real, vai apenas ser detectado pela
 * infraestrutura do FeedingSpot. Deste modo, a interface Receive deste modulo
 * tem apenas como fim servir de ponto de comunicacao entre o script e o modulo RFID,
 * para fazer testes;
 */
 
#endif