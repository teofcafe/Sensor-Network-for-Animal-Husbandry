COMPONENT=SensorMoteAppC
BUILD_EXTRA_DEPS = RequestMsg.py RequestMsg.class GPSCoordinateMessage.py GPSCoordinateMessage.class FeedingSpotMessage.py FeedingSpotMessage.class
CLEAN_EXTRA = RequestMsg.py RequestMsg.pyc RequestMsg.class RequestMsg.java GPSCoordinateMessage.py GPSCoordinateMessage.pyc GPSCoordinateMessage.class GPSCoordinateMessage.java FeedingSpotMessage.py FeedingSpotMessage.pyc FeedingSpotMessage.class FeedingSpotMessage.java
	
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

include $(MAKERULES)
