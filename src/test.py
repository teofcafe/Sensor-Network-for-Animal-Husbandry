#! /usr/bin/python

import sys
import random
import time

from TOSSIM import *
from RequestMsg import *
from GPSCoordinate import *

t = Tossim([])
r = t.radio()
f = open("topo.txt", "r")

for line in f:
  s = line.split()
  if s:
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(s[2]))

t.addChannel("SensorNetworkForAnimalHusbandryC", sys.stdout)
t.addChannel("Boot", sys.stdout)

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
  coord = GPSCoordinate()
  pkt = t.newPacket()
  coord.set_x(random.randrange(1, 10))
  coord.set_y(random.randrange(1, 10))
  pkt.setData(coord.data)
  pkt.setType(coord.get_amType())
  pkt.setDestination(i)
  pkt.deliver(i, i * 100)
  print "Delivering " + str(coord) + " for ", i; 

msg = RequestMsg()
pkt = t.newPacket()
pkt.setData(msg.data)
pkt.setType(msg.get_amType())
pkt.setDestination(1)

print "Delivering " + str(msg) + " to 1 at " + str(t.time() + 3);
pkt.deliver(1, t.time() + 1000)

for i in range(1000):
	t.runNextEvent()
