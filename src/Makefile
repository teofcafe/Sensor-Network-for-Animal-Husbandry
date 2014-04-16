COMPONENT=SensorNetworkForAnimalHusbandryAppC
BUILD_EXTRA_DEPS = RequestMsg.py RequestMsg.class
CLEAN_EXTRA = RequestMsg.py RequestMsg.class RequestMsg.java

RequestMsg.py: SensorNetworkForAnimalHusbandry.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=RequestMsg SensorNetworkForAnimalHusbandry.h request_msg -o $@

RequestMsg.class: RequestMsg.java
	javac RequestMsg.java
	
RequestMsg.java: SensorNetworkForAnimalHusbandry.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=RequestMsg SensorNetworkForAnimalHusbandry.h request_msg -o $@
	
include $(MAKERULES)
