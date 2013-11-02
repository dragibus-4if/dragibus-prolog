#!/bin/env python2.7

import sys

size_filter = int(sys.argv[1])
ls = [0.0] * size_filter

for line in sys.stdin.readlines():
    val = float(line.split('\n')[0])
    ls = ls[1:] + [val]
    print sum(ls) / size_filter
