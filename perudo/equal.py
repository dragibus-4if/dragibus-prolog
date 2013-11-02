#!/usr/bin/env python2.7

import sys

for line in sys.stdin.readlines():
    if line.split('\n')[0] == sys.argv[1]:
        print 1
    else:
        print 0
