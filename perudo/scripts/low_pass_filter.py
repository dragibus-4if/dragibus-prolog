#!/usr/bin/env python2.7

import sys

size_filter = int(sys.argv[1])
ls = [0.0] * size_filter
line = sys.stdin.readline()
t = 0
while line:
    val = float(line.split('\n')[0])
    ls = ls[1:] + [val]
    t += 1
    if t >= size_filter:
        print t, sum(ls) / size_filter
    line = sys.stdin.readline()
