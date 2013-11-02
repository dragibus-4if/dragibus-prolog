#!/bin/env python2.7
import sys
line = sys.stdin.readline()
t = 0
while line:
    print t, line.split('\n')[0]
    line = sys.stdin.readline()
