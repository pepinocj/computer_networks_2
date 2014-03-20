#!/usr/bin/python
import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2])
f3 = open(sys.argv[3])
out = open(sys.argv[4], 'w+')

while True:
	try:
		l1 = f1.readline().split(" ")
		print(l1)
		l2 = f2.readline().split(" ")
		print(l2)
		l3 = f3.readline().split(" ")
		print(l3)
		string = l1[0] + " " + l1[1] + " " + l2[1] + " " + l3[1]
		out.write(string + "\n")
	except IOError:
		break

f1.close()
f2.close()
f3.close()
out.close()
