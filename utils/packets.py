#!/usr/bin/python


import sys

infile = sys.argv[1];
granularity = float(sys.argv[2]);

f = open(infile)

clock = 0.0
prevpkt = 0
for line in f:
    time, pktno = line.split(' ')

    if (float(time) - clock > granularity):
        throughput = (int(pktno) - prevpkt) / granularity
        print(str(time) + " " + str(throughput))
        clock += granularity
        prevpkt = int(pktno)

throughput = (int(pktno) - prevpkt) / granularity
print(str(time) + " " + str(throughput))

f.close()
