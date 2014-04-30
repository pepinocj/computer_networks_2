#!/usr/bin/python
import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2])

while True:
	try:
		l1 = f1.readline().strip().split(" ")
		print(l1)
		l2 = f2.readline().strip().split(" ")
		print(l2)
		string = l1[0] + " " + l1[1] + " " + l2[1]
		print(string + "\n")
	except IndexError:
		break

f1.close()
f2.close()
