#! /usr/bin/python

import sys
import random
import time

from TOSSIM import *
from RequestMsg import *
from GPSCoordinateMessage import *
from FeedingSpotMessage import *
from RFID_test_message import *
from UpdateFoodQuantity import *

t = Tossim([])
r = t.radio()
f = open("topo.txt", "r")

print "\n~~~ Topology ~~~\n"

for line in f:
  s = line.split()
  if s:
    print " ", s[0], " ", s[1], " ", s[2];
    r.add(int(s[0]), int(s[1]), float(s[2]))

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
      
print "\n"

for i in range(1, 6):
  print "Creating noise model for ",i;
  t.getNode(i).createNoiseModel() 
  
while True:
	n = raw_input("\n*************************************************************************\n********** Sensor Network for Animal Husbandry - Laptop server **********\n*************************************************************************\n\n Commands: ~ [1] Turn on\n           ~ [2] Check information of an animal\n           ~ [3] Change amount of food in feeding spot\n           ~ [4] Change amount of food an animal can eat\n           ~ [5] Check how much food is left in the feeding spot\n           ~ [6] Turn off\n Actions:  ~ [7] Simulation of an animal eating from a feeding spot\n\n Command: ");
	if n.strip() == '1':
		for i in range(1, 6):
			t.getNode(i).turnOn()
			print "Node " + str(i) + " has turned on!"
			coord = GPSCoordinateMessage()
			pkt = t.newPacket()
			coord.set_x(random.randrange(1, 50))
			coord.set_y(random.randrange(1, 50))
			pkt.setData(coord.data)
			pkt.setType(coord.get_amType())
			pkt.setDestination(i)
			pkt.deliver(i, i * 10) 
		for j in range(1, 101): 
			feedingSpot = FeedingSpotMessage()
			feedingSpot.set_feedingSpotID(j)
			feedingSpot.set_foodAmount(random.randrange(1, 100))
			feedingSpot.set_type(1)
			for i in range(1, 6):
				pkt = t.newPacket()
				pkt.setData(feedingSpot.data)
				pkt.setType(feedingSpot.get_amType())
				pkt.setDestination(i)
				pkt.deliver(i, i * 10)
		for i in range(1000):
			t.runNextEvent()
	elif n.strip() == '2': 
		msg = RequestMsg()
		node = raw_input("  Node: ")
		msg.set_nodeID(int(node.strip()))
		pkt = t.newPacket()
		pkt.setData(msg.data)
		pkt.setType(msg.get_amType())
		near_node = raw_input("  Near node: ")
		pkt.setDestination(int(near_node.strip()))
		pkt.deliver(int(near_node.strip()), t.time())
		for i in range(1000):
			t.runNextEvent()	
	elif n.strip() == '3':
		feedingSpot = FeedingSpotMessage()
		feedingSpotID = raw_input(" Feeding spot ID: ")
		feedingSpot.set_feedingSpotID(int(feedingSpotID.strip()))
		feedingSpotFood = raw_input(" Feeding spot amount of food: ")
		feedingSpot.set_foodAmount(int(feedingSpotFood.strip()))
		feedingSpot.set_type(1)
		pkt = t.newPacket()
		pkt.setData(feedingSpot.data)
		pkt.setType(feedingSpot.get_amType())
		near_node = raw_input("  Near node: ")
		pkt.setDestination(int(near_node.strip()))
		pkt.deliver(int(near_node.strip()), t.time())
		for i in range(1000):
			t.runNextEvent()
	elif n.strip() == '4':
		changeFood = UpdateFoodQuantity()
		amountOfFood = raw_input(" Amount of food: ")
		changeFood.set_foodQuantity(int(amountOfFood.strip()))
		pkt = t.newPacket()
		pkt.setData(changeFood.data)
		pkt.setType(changeFood.get_amType())
		near_node = raw_input("  Near node: ")
		pkt.setDestination(int(near_node.strip()))
		pkt.deliver(int(near_node.strip()), t.time())
		for i in range(1000):
			t.runNextEvent()
	elif n.strip() == '5':
		feedingSpot = FeedingSpotMessage()
		feedingSpotID = raw_input(" Feeding spot ID: ")
		feedingSpot.set_feedingSpotID(int(feedingSpotID.strip()))
		feedingSpot.set_type(0)
		pkt = t.newPacket()
		pkt.setData(feedingSpot.data)
		pkt.setType(feedingSpot.get_amType())
		near_node = raw_input("  Near node: ")
		pkt.setDestination(int(near_node.strip()))
		pkt.deliver(int(near_node.strip()), t.time())
		for i in range(1000):
			t.runNextEvent()
	elif n.strip() == '6':
		for i in range(1, 6):
			t.getNode(i).turnOff()
			print "Node " + str(i) + " has turned off!"
		break;
	elif n.strip() == '7':
		mskt = RFID_test_message()
		pkt = t.newPacket()
		pkt.setData(mskt.data)
		pkt.setType(mskt.get_amType())
		near_node = raw_input("  Near node: ")
		pkt.setDestination(int(near_node.strip()))
		pkt.deliver(int(near_node.strip()), t.time())
		for i in range(1000):
			t.runNextEvent()
