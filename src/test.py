#! /usr/bin/python

import sys
import random
import time

from TOSSIM import *
from RequestMsg import *
from GPSCoordinateMessage import *
from FeedingSpotMessage import *
from RFID_test_message import *

t = Tossim([])
r = t.radio()
f = open("topo.txt", "r")

for line in f:
  s = line.split()
  if s:
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(s[2]))

t.addChannel("SensorMoteC", sys.stdout)
t.addChannel("GPSCoordinateSensorC", sys.stdout)
t.addChannel("RadioFrequencySensorC", sys.stdout)
t.addChannel("MemoryC", sys.stdout)
t.addChannel("RFIDSensorC", sys.stdout)

noise = open("meyer-heavy.txt", "r")
for line in noise:
  str1 = line.strip()
  if str1:
    val = int(str1)
    for i in range(1, 6):
      t.getNode(i).addNoiseTraceReading(val)
 
for i in range(1, 6):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel()
  t.getNode(i).turnOn()
  coord = GPSCoordinateMessage()
  pkt = t.newPacket()
  coord.set_x(random.randrange(1, 10))
  coord.set_y(random.randrange(1, 10))
  pkt.setData(coord.data)
  pkt.setType(coord.get_amType())
  pkt.setDestination(i)
  pkt.deliver(i, i * 100)
  print "Delivering " + str(coord) + " for ", i; 
  
for j in range(1, 10): 
  feedingSpot = FeedingSpotMessage()
  feedingSpot.set_feedingSpotID(j)
  feedingSpot.set_foodAmount(random.randrange(1, 100))
  for i in range(1, 6):
	pkt = t.newPacket()
	pkt.setData(feedingSpot.data)
	pkt.setType(feedingSpot.get_amType())
	pkt.setDestination(i)
	pkt.deliver(i, i * 100)
	print "sending to ", i;
  print "Delivering " + str(feedingSpot) + " for ", i;

for i in range(1000):
	t.runNextEvent()
	
msg = RequestMsg()
msg.set_nodeID(5)
pkt = t.newPacket()
pkt.setData(msg.data)
pkt.setType(msg.get_amType())
pkt.setDestination(1)
print "Delivering " + str(msg) + " to 1 at " + str(t.time() + 3);
pkt.deliver(1, t.time() + 1000)

for i in range(1000):
	t.runNextEvent()

mskt = RFID_test_message()
pcktrfid = t.newPacket()
mskt.set_feedingSpot(4)
pcktrfid.setData(mskt.data)
pcktrfid.setType(mskt.get_amType())
pcktrfid.setDestination(4)
print "Delivering " + str(mskt) + " to 4 at " + str(t.time() + 3);
pcktrfid.deliver(4, t.time() + 1000)

for i in range(1000):
	t.runNextEvent()
