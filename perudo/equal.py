#!/bin/env python2.7
import sys
line = sys.stdin.readline()
while line:
    if line.split('\n')[0] == sys.argv[1]:
        print 1
    else:
        print 0
    line = sys.stdin.readline()
