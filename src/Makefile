COMPONENT=SensorNetworkForAnimalHusbandryAppC
BUILD_EXTRA_DEPS = RequestMsg.py RequestMsg.class GPSCoordinate.py GPSCoordinate.class
CLEAN_EXTRA = RequestMsg.py RequestMsg.class RequestMsg.java GPSCoordinate.py GPSCoordinate.class GPSCoordinate.java

RequestMsg.py: SensorNetworkForAnimalHusbandry.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RequestMsg SensorNetworkForAnimalHusbandry.h request_msg -o $@

RequestMsg.class: RequestMsg.java
	javac RequestMsg.java
	
RequestMsg.java: SensorNetworkForAnimalHusbandry.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RequestMsg SensorNetworkForAnimalHusbandry.h request_msg -o $@
	
GPSCoordinate.py: SensorNetworkForAnimalHusbandry.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=GPSCoordinate SensorNetworkForAnimalHusbandry.h GPSCoordinate -o $@

GPSCoordinate.class: GPSCoordinate.java
	javac GPSCoordinate.java
	
GPSCoordinate.java: SensorNetworkForAnimalHusbandry.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=GPSCoordinate SensorNetworkForAnimalHusbandry.h GPSCoordinate -o $@
	
include $(MAKERULES)
