COMPONENT=SensorMoteAppC
BUILD_EXTRA_DEPS = GPSCoordinateMessage.py GPSCoordinateMessage.class FeedingSpotMessage.py FeedingSpotMessage.class
CLEAN_EXTRA = GPSCoordinateMessage.py GPSCoordinateMessage.pyc GPSCoordinateMessage.class GPSCoordinateMessage.java FeedingSpotMessage.py FeedingSpotMessage.pyc FeedingSpotMessage.class FeedingSpotMessage.java
	
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
