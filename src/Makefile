COMPONENT=SensorMoteAppC
BUILD_EXTRA_DEPS = RequestMsg.py RequestMsg.class GPSCoordinateMessage.py GPSCoordinateMessage.class FeedingSpotMessage.py FeedingSpotMessage.class RFID_test_message.py RFID_test_message.class UpdateFoodQuantity.py UpdateFoodQuantity.class
CLEAN_EXTRA = RequestMsg.py RequestMsg.pyc RequestMsg.class RequestMsg.java GPSCoordinateMessage.py GPSCoordinateMessage.pyc GPSCoordinateMessage.class GPSCoordinateMessage.java FeedingSpotMessage.py FeedingSpotMessage.pyc FeedingSpotMessage.class FeedingSpotMessage.java RFID_test_message.py RFID_test_message.pyc RFID_test_message.class RFID_test_message.java UpdateFoodQuantity.py UpdateFoodQuantity.pyc UpdateFoodQuantity.class UpdateFoodQuantity.java	
	
RequestMsg.py: SensorMote.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RequestMsg SensorMote.h request_msg -o $@

RequestMsg.class: RequestMsg.java
	javac RequestMsg.java
	
RequestMsg.java: SensorMote.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RequestMsg SensorMote.h request_msg -o $@
	
GPSCoordinateMessage.py: SensorMote.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=GPSCoordinateMessage SensorMote.h GPSCoordinateMessage -o $@

GPSCoordinateMessage.class: GPSCoordinateMessage.java
	javac GPSCoordinateMessage.java
	
GPSCoordinateMessage.java: SensorMote.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=GPSCoordinateMessage SensorMote.h GPSCoordinateMessage -o $@
	
FeedingSpotMessage.py: SensorMote.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=FeedingSpotMessage SensorMote.h FeedingSpotMessage -o $@

FeedingSpotMessage.class: FeedingSpotMessage.java
	javac FeedingSpotMessage.java
	
FeedingSpotMessage.java: SensorMote.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=FeedingSpotMessage SensorMote.h FeedingSpotMessage -o $@
	
RFID_test_message.py: SensorMote.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RFID_test_message SensorMote.h RFID_test_message -o $@

RFID_test_message.class: RFID_test_message.java
	javac RFID_test_message.java
	
RFID_test_message.java: SensorMote.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RFID_test_message SensorMote.h RFID_test_message -o $@
	
UpdateFoodQuantity.py: SensorMote.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=UpdateFoodQuantity SensorMote.h UpdateFoodQuantity -o $@

UpdateFoodQuantity.class: UpdateFoodQuantity.java
	javac UpdateFoodQuantity.java
	
UpdateFoodQuantity.java: SensorMote.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=UpdateFoodQuantity SensorMote.h UpdateFoodQuantity -o $@

include $(MAKERULES)
