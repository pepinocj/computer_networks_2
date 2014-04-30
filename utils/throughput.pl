#!/usr/bin/perl

#type: throughput.pl <trace file> <required node> <granularity> > outputfile

# NOTE: required node == the (destination) node where you want to compute the throughput in

import sys

infile = sys.argv[0];
tonode = sys.argv[1];
granularity = sys.argv[2];

f = infile.open()
for line in f.readlines():
	event, time, frm, to, pkttype, pktsize, rest = line.split()

	if (time - clock > granularity):
	    throughput = sum / granularity
	    print(str(time) + " " + str(throughput))
		clock += granularity
		sum = 0

	if ( (event == "r") and (to == tonode) and (pkttype == "tcp")):
		sum += pktsize;

throughput = sum / granularity;
print(str(time) + " " + str(throughput))

f.close()
